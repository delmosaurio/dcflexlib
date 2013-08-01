package dc.events
{
	import flash.events.Event;
	
	public class ProxyEvent extends Event
	{
		public static const ERROR:String = "proxyError";
		
		public static const CALL_BEGIN:String = "callBegin";
		
		public static const CALL_COMPLETE:String = "callComplete";
		
		[Bindable]
		public var message:String = "";
		
		[Bindable]
		public var messageId:String = "";
		
		public function ProxyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}