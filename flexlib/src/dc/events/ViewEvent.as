package dc.events
{
	import flash.events.Event;
	
	public class ViewEvent extends Event {
	
		public var data:*;
		
		public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}