package dc.events
{
	import flash.events.Event;
	
	import spark.events.TextOperationEvent;
	
	public class ThrottleEvent extends Event
	{
		
		public var operationEvent:TextOperationEvent;
		
		public var throttle:int=0;
		
		public static const THROTTLE:String = "textChangeThrottle";
		
		public function ThrottleEvent(oe:TextOperationEvent, t:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super("textChangeThrottle", bubbles, cancelable);
			
			this.operationEvent=oe;
			this.throttle=t;
		}
	}
}
