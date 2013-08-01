package dc.mvc
{
	import dc.events.ProxyEvent;
	import dc.rpc.ProxyBase;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	[Event(name="proxyError", type="dc.events.ProxyEvent")]
	[Event(name="callBegin", type="dc.events.ProxyEvent")]
	[Event(name="callComplete", type="dc.events.ProxyEvent")]
	public class ModelService implements IEventDispatcher
	{
		
		public static const UNDEFINED:String = "undefined";
		public static const BUSY:String = "busy";
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		private var _proxies:ArrayCollection;
		
		private var _proxyStates:Dictionary;
		
		private var _callerStack:ArrayCollection;
		
		[Bindable]public var status:String = UNDEFINED;
		
		public function ModelService() {
				
		}
		
		private function get proxies() : ArrayCollection {
			if (_proxies==null) {
				_proxies = new ArrayCollection();
			}
			
			return _proxies;
		}
		
		private function get callerStack() : ArrayCollection {
			if (_callerStack==null) {
				_callerStack = new ArrayCollection();
			}
			
			return _callerStack;
		}
		
		private function get proxyStates() : Dictionary {
			if (_proxyStates==null) {
				_proxyStates = new Dictionary();
			}
			
			return _proxyStates;
		}
		
		protected function addProxy(proxy:ProxyBase) : void {
			
			if (!proxy) return;
			
			//ADD LISTENERS
			proxyStates[proxy] = UNDEFINED;
			proxies.addItem( proxy );
			
			proxy.addEventListener(ProxyEvent.CALL_BEGIN, proxyCallBeginHandler);
			proxy.addEventListener(ProxyEvent.CALL_COMPLETE, proxyCallCompleteHandler);
			proxy.addEventListener(ProxyEvent.ERROR, proxyErrorHandler);
		}
		
		protected function proxyErrorHandler(event:ProxyEvent):void {
			var p:ProxyBase = event.target as ProxyBase;
			
			proxyStates[p] = ProxyEvent.ERROR;
			
			checkStatus(p, event);
		}
		
		protected function proxyCallCompleteHandler(event:ProxyEvent):void {
			var p:ProxyBase = event.target as ProxyBase;
			
			proxyStates[p] = ProxyEvent.CALL_COMPLETE;
			
			callerStack.removeItemAt( callerStack.getItemIndex(p) )
			
			checkStatus(p, event);
		}
		
		protected function proxyCallBeginHandler(event:ProxyEvent):void {
			var p:ProxyBase = event.target as ProxyBase;
			
			proxyStates[p] = ProxyEvent.CALL_BEGIN;
			
			callerStack.addItem( p );
			
			checkStatus(p, event);
		}
		
		private function checkStatus(proxy:ProxyBase, event:ProxyEvent):void {
						
			if (status == ERROR) return;
			
			if (event.type == ProxyEvent.CALL_BEGIN) {
				
				if (callerStack.length == 1) {
					status = BUSY;
					dispatchEvent( event );
				}
				
			} else if (event.type == ProxyEvent.CALL_COMPLETE) {
				
				if (callerStack.length == 0) {
					status = COMPLETE;
					dispatchEvent( event );
				}
				
			} else if (event.type == ProxyEvent.ERROR) {
				status = ERROR;
				dispatchEvent( event );
			}
			
		}
		
		public function resideError() : void {
			
			for each(var key:ProxyBase in proxyStates) {
				proxyStates[key] = UNDEFINED;
			}
			callerStack.removeAll();
			
		}
				
		/* IEventDispatcher */
		
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