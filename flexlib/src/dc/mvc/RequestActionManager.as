package dc.mvc
{
	import dc.core.RequestManager;
	import dc.dev.Console;
	import dc.events.RequestActionEvent;
	import dc.events.RequestEvent;
	import dc.utils.RequestUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.HashArray;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	
	[Event(name="requestView", type="dc.events.RequestActionEvent")]
	[Event(name="requestViewError", type="dc.events.RequestActionEvent")]
	/***
	 * Singleton class
	 * 
	 * <p>
	 * Esta clase es la encargada de conocer todas las RequestView de una EgoApplication
	 * debe inicializarse en el preinitialize handler de la aplicacion principal e indicar 
	 * todas las RequestView ahi.
	 * </p>
	 * 
	 * <p>
	 * <code>
	 * RequestViewManager.getInstance().initialize("app.modules");
	 * 
	 * RequestViewManager.getInstance().register( app.modules.module1.view.Index );
	 * RequestViewManager.getInstance().register( app.modules.module2.view.Index );
	 * RequestViewManager.getInstance().register( app.modules.module2.section1.view.Home );
	 * RequestViewManager.getInstance().register( app.modules.module3.view.Index );
	 * </code>
	 * </p>
	 * 
	 */
	public class RequestActionManager	implements IEventDispatcher{
		
		private static var _instance:RequestActionManager;
		
		private var dispatcher:EventDispatcher;
		
		[ArrayElementType("dc.mvc.RegisteredController")]
		private var _controllers:Array = new Array();
		
		private var _initialized:Boolean = false;
		
		public var defaultAction:String="Index";
		
		private var logger:Console = Console.getInstance();
		
		[ArrayElementType("String")]
		public var _paths:Array;
		
		[ArrayElementType("String")]
		public var _actions:Array;
		
		public function RequestActionManager() {
			if (_instance != null)
				throw new Error("Singleton - Can't Instanstiate");
			
			_instance = this;
			
			dispatcher = new EventDispatcher(this);
		}
		
		public static function getInstance():RequestActionManager {
			if (_instance == null)
				_instance = new RequestActionManager();
			
			return _instance;
		}
		
		public function initialize() : void {
			RequestManager.getInstance().addEventListener(RequestEvent.REQUEST, requestHandler);
			
			_initialized = true;
		}
				
		public function register(controller:*) : void {
			
			/*if (!_initialized) 
					throw new Error("The class is not initialized.");*/
			
			var rc:RegisteredController = new RegisteredController();
			
			if (rc.create(controller)) {
				registerController(rc);
			}
			
		}
		
		private function registerController(rc:RegisteredController) : void  {
			controllers.push( rc );
			
			for each (var a:RequestAction in rc.actions) {
				
				var sa:String = a.action.toLowerCase();

				//ADD action
				if (!ArrayUtils.contains(distinctsActions, sa)){
					distinctsActions.push( sa );
				}
				
				//ADD path
				if (!ArrayUtils.contains(distinctsPaths, a.getPath().toLowerCase())){
					distinctsPaths.push(a.getPath().toLowerCase());
				}
				
			}
			
			logger.log( "controller registerd: " + rc );
			
    	}
		
		public function get controllers() : Array {
			/*if (!_initialized) 
				throw new Error("The class is not initialized.");
			*/
			if (_controllers==null) 
				_controllers=new Array();
			
			return _controllers;
		}
		
		[ArrayElementType("String")]
		private function get distinctsPaths() : Array {
			if (_paths==null) 
				_paths = new Array();
			
			return _paths;
		}
		
		[ArrayElementType("String")]
		private function get distinctsActions() : Array {
			if (_actions==null) 
				_actions = new Array();
			
			return _actions;
		}
		
		protected function requestHandler(event:RequestEvent):void {
			
			var cp:String = RequestUtils.extractPathFragment( event.url );
			var context:RequestContext = resolve(event.url);
						
			var re:RequestActionEvent = new RequestActionEvent(RequestActionEvent.REQUEST_ACTION, event);
			re.context = context;
			re.params = RequestUtils.extractParams(event.url);
				
			dispatchEvent( re );
			
		}

		private function resolve(url:String) : RequestContext {
			
			var cp:String = RequestUtils.extractPathFragment( url );
						
			var ma:String = RequestUtils.mapAction( cp );
			var mp:String = RequestUtils.mapPath( cp );
			
			var toResolve:String = "";
			
			if ( actionExist(ma) ) {
				toResolve = ma;
			} else if (pathExist(ma)) {
				toResolve = StringUtils.substitute("{0}.{1}", mp, defaultAction);
			}
			
			if (toResolve == "") return null;
			
			return resolveAction( toResolve );
			
		}
		
		private function resolveAction(action:String) : RequestContext {
			
			var ra:RequestContext= new RequestContext(RequestContextType.NONE);
			
			for each (var rc:RegisteredController in controllers) {
				if (!rc.hasAction(action)) continue;
				
				ra = new RequestContext(RequestContextType.CONTROLLER);
				ra.actionName = action;
				ra.action = rc.getAction( action );
				ra.target = rc;
				
				break;
			}
			
			return ra;
		}
		
		private function actionExist(action:String) : Boolean {
			return ArrayUtils.contains( distinctsActions, action.toLowerCase() );
		}

		private function pathExist(path:String) : Boolean {
			return ArrayUtils.contains( distinctsPaths, path.toLowerCase() );
		}
		
		/* IEventDispatcher */
		
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