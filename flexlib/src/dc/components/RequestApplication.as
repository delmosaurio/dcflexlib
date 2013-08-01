package dc.components
{
	import dc.core.RequestManager;
	import dc.events.RequestActionEvent;
	import dc.events.RequestEvent;
	import dc.events.RequestViewEvent;
	import dc.mvc.RegisteredController;
	import dc.mvc.RequestAction;
	import dc.mvc.RequestActionManager;
	import dc.mvc.RequestContextType;
	import dc.mvc.RequestController;
	import dc.utils.RequestUtils;
	
	import flash.events.Event;
	import flash.geom.Utils3D;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.URLUtil;
	
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Type;

	[Event(name="requestView", type="dc.events.RequestViewEvent")]
	/**
	 * 
	 * <p>Please register all controller class in the initialize time.</p>
	 * 
	 */
	public class RequestApplication extends DcApplication
	{		
		
		public var initRequest:String = "!/";
		
		private var _controlers:Dictionary;
		
		public function RequestApplication() {
			super();
			
			/*
			actionManager.initialize();
			
			this.addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
			this.addEventListener(FlexEvent.INITIALIZE, initializeHandler);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			*/
		}
		
		protected function initAll() : void {
			actionManager.initialize();
			
			requestManager.addEventListener(RequestEvent.INVALID_REQUEST, requestInvalid);
			requestManager.addEventListener(RequestEvent.REQUEST, requestHandler);
			actionManager.addEventListener(RequestActionEvent.REQUEST_ACTION, requestActionHandler);
			
			requestManager.init(initRequest, true);
		}
		
		/* Handlers */
		private function preinitializeHandler(event:FlexEvent):void {
			//actionManager.initialize();
		}
		
		private function initializeHandler(event:FlexEvent):void {
			
		}
		
		private function creationCompleteHandler(event:FlexEvent):void {
			
		}
		
		private function requestActionHandler(event:RequestActionEvent):void {
			
			logger.log("action requested: " + event.context);
			
			if (event.context && event.context.type == RequestContextType.CONTROLLER ) {
				requestController(event.context.action, event.context.target, event);
			}
		}
		
		private function requestHandler(event:RequestEvent):void {
			this.hasBackAction = requestManager.hasBack;
			this.hasForwardAction = requestManager.hasForward;
		}
		
		private function requestInvalid(event:RequestEvent):void {
			
		}
		/* Handlers */
		
		/* Managers */
		public function get actionManager() : RequestActionManager {
			return RequestActionManager.getInstance();
		}
		
		public function get requestManager() : RequestManager {
			return RequestManager.getInstance();
		}
		/* Managers */
		
		/* Members */
		
		private function requestController(action:RequestAction, controller:RegisteredController,event:RequestActionEvent) : void {
			if (!action || !controller || !action.method) return;
			
			var rc:RequestController = getController(controller.controllerClass);
			
			var instance:RequestView = rc.requestView(
									action.method.returnType.clazz,
									event
								);
			
			var vi:* = action.method.invoke(rc, [instance, event]) as IVisualElement
				
			var re:RequestViewEvent = new RequestViewEvent(RequestViewEvent.REQUEST_VIEW, event);
			re.view = vi;
			
			setTitle( action.title );
			
			re.ruleRequired = action.rule;
			re.flagRequired = action.flag;
			
			dispatchEvent(re);
		}
		
		protected function register(controller:*) : void {
			actionManager.register(controller);	
		}
		
		public function get controllers() : Dictionary {
			if (_controlers==null)
				_controlers = new Dictionary()
			
			return _controlers;
		}
		
		public function getController(classController:Class) : RequestController {
			
			var fn:String = Type.forClass(classController).fullName;
			
			if (controllers[fn] == null) {
				controllers[fn] = new classController();
			}
			return controllers[fn] as RequestController;
		}
		
		public function backAction() : Boolean {
			return requestManager.back();	
		}
		
		public function forwardAction() : Boolean {
			return requestManager.forward();
		}
		
		private var _hasBackAction:Boolean=false;
		
		private var _hasForwardAction:Boolean=false;
		
		[Bindable]
		public function get hasBackAction() : Boolean {
			return _hasBackAction;
		}
		
		public function set hasBackAction(value:Boolean) : void {
			_hasBackAction = value;
		}
		
		[Bindable]
		public function get hasForwardAction() : Boolean {
			return _hasForwardAction;
		}
		
		public function set hasForwardAction(value:Boolean) : void {
			_hasForwardAction = value;
		}
		
		public function setTitle(title:String) : void {
			requestManager.setTitle( title );
		}
		
		public function goTo(url:String, params:*=null) : void {
			
			var to:String=url;
			
			if (params) {
				to = StringUtils.substitute("{0}?{1}", url, URLUtil.objectToString(params, "&"));
			}
			
			requestManager.goTo( to );
		}
		
		public function lockAppiclation() : void {
		}
		
		public function unlockAppiclation() : void {
		}
		
		public function iamIn(path:String) : Boolean {
			
			var luri:String = requestManager.getLastUrl();
			var p:Array = RequestUtils.extractPathFromUrl( luri );
			var ap:Array = RequestUtils.extractPath(path);
			
			if (!ap || !p) return false;
			
			if (ap.length != p.length) return false;
			
			for (var i:int=0;i<ap.length;i++) {
				if (!ap[i] || !p[i]) return false;
				
				if (ap[i].toString().toLowerCase() != p[i].toString().toLowerCase()) return false; 
			}
			
			return true; 
		}
		
		/* Members */
	}
}