package dc.events
{
	import dc.mvc.RegisteredController;
	import dc.mvc.RegisteredView;
	import dc.mvc.RequestContext;
	
	import flash.events.Event;
	
	public class RequestActionEvent extends RequestEvent
	{
		public static const REQUEST_ACTION:String = "requestAction";
		
		public var context:RequestContext=null;
		
		public var params:*;
		
		public var baseEvent:RequestEvent;
		
		public function RequestActionEvent(type:String, requestEvent:RequestEvent, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			//Esto me parece que esta mal
			this.isPostBack = requestEvent.isPostBack;
			this.url = requestEvent.url;
			this.fromApp = requestEvent.fromApp;
			this.isBack = requestEvent.isBack;
			this.isForward = requestEvent.isForward;
			
			baseEvent = requestEvent;
			
		}
		
		public function hasContext() : Boolean {
			return context != null;
		}
		
	}
}