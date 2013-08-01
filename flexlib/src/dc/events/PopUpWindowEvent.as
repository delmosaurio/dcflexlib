package dc.events
{
	import flash.events.Event;
	
	public class PopUpWindowEvent extends Event
	{
		public var data:*;
		
		public function PopUpWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}