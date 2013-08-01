package dc.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public var data:* = null;
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}