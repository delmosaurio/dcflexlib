package dc.events
{
	import mx.core.IVisualElement;

	public final class RequestViewEvent extends RequestActionEvent
	{
		public static const REQUEST_VIEW:String = "requestView";
		
		public var view:IVisualElement;
		
		public var ruleRequired:String = "";
		
		public var flagRequired:* = "";
		
		public function RequestViewEvent(type:String, requestAction:RequestActionEvent, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, requestAction.baseEvent, bubbles, cancelable);
			
			this.context = requestAction.context;
			this.params = requestAction.params;
			
		}
	}
}