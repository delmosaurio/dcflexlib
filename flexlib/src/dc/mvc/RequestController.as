package dc.mvc
{
	import dc.components.RequestApplication;
	import dc.components.RequestView;
	import dc.core.RequestManager;
	import dc.events.RequestActionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;
	
	public class RequestController implements IEventDispatcher
	{
		
		private var _viewData:Dictionary;
		
		private var _intances:Dictionary;
		
		private var _cache:Dictionary;
		
		public function RequestController() {
			
		}
		
		public function doPostBack() : void {
			RequestManager.getInstance().doPostBack();
		}
		
		protected function get viewData() : Dictionary {
			if (_viewData==null) {
				_viewData = new Dictionary();;
			}
			
			return _viewData;
		}
		
		protected function get intances() : Dictionary {
			if (_intances==null) {
				_intances = new Dictionary();;
			}
			
			return _intances;
		}
		
		protected function get cache() : Dictionary {
			if (_cache==null) {
				_cache = new Dictionary();
			}
			
			return _cache;
		}
		
		public function getInstace(cl:Class,create:Boolean=true,persist:Boolean=false) : * {
			
			if (intances[cl] == null || (create && !persist)) {
				intances[cl] = new cl();
				intances[cl].controller = this;
			}
			
			return intances[cl];
		}
		
		public function getViewData(instanse:*) : Dictionary {
			if (viewData[instanse] == null) {
				viewData[instanse] = new Dictionary();
			}
			
			return viewData[instanse] as Dictionary;
		}
		
		public function requestView(cl:Class, event:RequestActionEvent) : RequestView {
			
			var create:Boolean = !event.isPostBack && !event.isBack && !event.isForward;
			
			var res:RequestView = getInstace(cl, create, event.context.action.persist);
						
			//merge params
			try
			{
				if (event.params) {
					for (var key:String in event.params) {
						trace(key);
						res.viewData[key] = event.params[key];
					}
				}
			}
			catch(err:Error) {
			}
			
			return res;
		}
		
		protected function goTo(url:String, params:*=null) : void {
			var app:RequestApplication = FlexGlobals.topLevelApplication as RequestApplication;
			app.goTo(url, params);
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
