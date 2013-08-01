package dc.core
{
	import dc.dev.Console;
	import dc.events.RequestEvent;
	import dc.utils.RequestUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	
	import mx.events.BrowserChangeEvent;
	import mx.managers.BrowserManager;
	import mx.managers.HistoryManager;
	import mx.managers.IBrowserManager;
	import mx.managers.IHistoryManagerClient;
	
	[Event(name="request", type="dc.events.RequestEvent")]
	[Event(name="invalidRequest", type="dc.events.RequestEvent")]
	/**
	 * <b>Singleton</b>
	 * <p>Listen when the browser changes the url and dispatch a RequestEvent event.</p>
	 */
	public class RequestManager implements IEventDispatcher
	{
		
		public var initRquest:String = "!/"; 
		
		public var browserInitialized:Boolean=false;
		
		public var _stack:Array;
		
		public var preventWrongUrl:Boolean=false;
		
		private var _preventingWrongUrl:Boolean = false;
		
		private var _init:Boolean = false;
		
		private var _index:uint=0;
		
		private var _internalChange:Boolean= false;
		
		private var logger:Console = Console.getInstance();
		
		/**
		 * Regular expression to use for validate url.
		 * @default <b>/^!(\/(?<=\/)[A-z0-9_\.]*)((\/(?<=\/)[\A-z0-9_\.]+)?)*\/?(\?[\A-z0-9_&\=\.]*)*?$/</b>
		 */
		public var validUrlRegex:RegExp=/^!(\/(?<=\/)[A-z0-9_\.]*)((\/(?<=\/)[\A-z0-9_\.]+)?)*\/?(\?[\A-z0-9_&\=\.]*)*?$/;
		
		/* Singleton */
		private static var _instance:RequestManager;
		
		/**
		 * Singleton - Can't Instanstiate
		 */
		public function RequestManager() {
			if (_instance != null)
				throw new Error("Singleton - Can't Instanstiate");
			
			_instance = this;
		}
		
		public static function getInstance():RequestManager {
			if (_instance == null)
				_instance = new RequestManager();
			
			return _instance;
		}
		
		public function get isInitialized() : Boolean {
			return _init;
		}
		
		/* Singleton */
		
		/**
		 *	Initialize the RequestManager
		 * 
		 * @param ir initRquest - First request for initialize de browser
		 * @param preventUrl (preventWrongUrl extarnal accesor)<p> Determines whether the RequestManager discart wrong url use de <b>validUrlRegex</b> for validate the url and dispatch an <b>RequestEvent.INVALID_REQUEST</b> event.</p> 
		 * @param regexUrl (validUrlRegex extarnal accesor)<p>Regular expression to use for validate url when <b>preventWrongUrl</b> is true</p>
		 * 
		 * @see dc.events.RequestEvent.INVALID_REQUEST 
		 */
		public function init(ir:String="!/", preventUrl:Boolean=false, regexUrl:*=null) : void {
			
			initRquest=ir;
			preventWrongUrl = preventUrl;
			setValidUrlRegex(regexUrl);
			
			logger.log("RequestManager initialized at " + initRquest);
			
			initializeBrowser();
			_init = true;
		}
		
		private function setValidUrlRegex(regexUrl:*="") : void {
			if (!regexUrl	|| regexUrl =="") return;
			
			if (regexUrl is String) {
				validUrlRegex = new RegExp(regexUrl);
			} else if (regexUrl is RegExp) {
				validUrlRegex = regexUrl as RegExp;
			}
			
		}
		
		private function get browser() : IBrowserManager {
			return BrowserManager.getInstance();
		}
		
		private function initializeBrowser():void {
			
			//browser.init();
			browser.initForHistoryManager();
			
			if (browser.fragment=="") {
				browser.setFragment( initRquest );
			} else {
				request(browser.fragment);
			}
			
			browser.addEventListener(BrowserChangeEvent.URL_CHANGE, urlChangeHandler);
			browser.addEventListener(BrowserChangeEvent.APPLICATION_URL_CHANGE, appUrlChangeHandler);
			browser.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, browserUrlChangeHandler);
			
			browserInitialized = true;
			
			logger.log("RequestManager browser initialized" );
			
		}
		
		private function urlChangeHandler(event:BrowserChangeEvent):void {
			if (!browserInitialized) return;	
		}
		
		private function appUrlChangeHandler(event:BrowserChangeEvent):void {
			if (!browserInitialized) return;
			
			if (stack.length == 0 && browser.fragment == ""){
				return; //BUG solved
			}
			
			if (!_internalChange) {
				request(browser.fragment, true);	
			} else {
				_internalChange=false;
			}
			
		}
		
		private function browserUrlChangeHandler(event:BrowserChangeEvent):void {
			if (!browserInitialized) return;
			
			if (stack.length == 0 && browser.fragment == ""){
				return; //BUG solved
			}
			
			request(browser.fragment);
		}
		
		protected function internalRequest(url:String="", fromApp:Boolean=false, register:Boolean=true, idBack:Boolean=false, isForward:Boolean=false) : void {
			_internalChange = true;
			browser.setFragment(url);
			
			request(url, fromApp, register, idBack, isForward);
		}
		
		protected function request(url:String="", fromApp:Boolean=false, register:Boolean=true, idBack:Boolean=false, isForward:Boolean=false) : void {
			var msg:String = "";
			msg += "'" + url;
			msg += "' [fromApp=" + fromApp + ", ";
			msg += " register=" + register + ", ";
			msg += " idBack=" + idBack + ", ";
			msg += " isForward=" + isForward + "]";
				
			logger.info( "request: " + msg);
			
			if (_preventingWrongUrl) {
				_preventingWrongUrl = false; 
				return;
			}
			
			if (!_preventingWrongUrl && !validUrl(url)) {
				var err:RequestEvent = new RequestEvent(RequestEvent.INVALID_REQUEST);
				
				err.fromApp = fromApp;
				err.url = url;
				
				dispatchEvent( err );
				
				preventingWrongUrl();
				
				return;
			}
			
			var ip:Boolean = (idBack || isForward)? false : isPostBack(url);
			
			if (register)
				_index=(stack.push( url ) - 1); //TODO implemet if is app 
			
			var re:RequestEvent = new RequestEvent(RequestEvent.REQUEST);
			
			re.fromApp = fromApp;
			re.url = url;
			re.isPostBack = ip;
			re.isBack = idBack;
			re.isForward = isForward;
			
			dispatchEvent( re );
			
		}
		
		private function preventingWrongUrl():void {
			_preventingWrongUrl = true;
			
			if (stack.length > 0) {
				browser.setFragment(stack[stack.length-1]); 
			} else {
				browser.setFragment(initRquest); 
			}
		}
		
		private function validUrl(url:String):Boolean {
			return validUrlRegex.test(url);
		}
		
		private function isPostBack(url:String):Boolean {
			
			try {
				var ml:String = RequestUtils.extractPathFragment(getLastUrl());
				var mc:String = RequestUtils.extractPathFragment(url);
				
				return ml == mc;
				
			} catch (err:Error) {
			}
			
			return false;
		}
		
		public function getLastUrl() : String {
			
			if (stack.length==0) {
				return "";
			}
			
			return stack[stack.length-1];
		}
		
		[ArrayElementType("String")]
		public function get stack() : Array {
			if (_stack==null)
				_stack = new Array();
			
			return _stack;
		}
		
		public function doPostBack() : void {
			request(browser.fragment, true);
		}
		
		public function get hasBack() : Boolean {
			return _index>0;
		}
		
		public function get hasForward() : Boolean {
			return _index<(stack.length-1);
		}
		
		public function back() : Boolean {
			if (hasBack) {
				return requestIndex(_index-1, true);
			}
			return false;
		}
		
		public function forward() : Boolean {
			if (hasForward) {
				return requestIndex(_index + 1, false, true);
			}
			return false;
		}
		
		private function requestIndex(index:uint, isBack:Boolean=false, isForward:Boolean=false) : Boolean {
			if (index >= 0 && index < stack.length) {
				_index = index;
				var uri:String = stack[_index];
				internalRequest(uri, true, false, isBack, isForward);
				return true;
			}
			
			return false;
		}
		
		public function setTitle(title:String) : void {
			browser.setTitle(title);
		}
		
		public function goTo(url:String) : void {
			browser.setFragment(url);
		}
		
		
		/* IEventDispatcher Prepare this class for dispatch events */
		
		private var _dispatcher:EventDispatcher;
		
		private function get dispatcher() : EventDispatcher {
			if (_dispatcher==null)
				_dispatcher= new EventDispatcher(this);
			
			return _dispatcher;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		/* IEventDispatcher */
		
	}
}