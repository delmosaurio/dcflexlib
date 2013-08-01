package dc.events
{
	import flash.events.Event;
	
	public class LoggerEvent extends Event
	{
		public static const LOG:String = "log";
		
		public static const INFO:String = "info";
		
		public static const ERROR:String = "error";
		
		public var entry:String = null;
		
		public function LoggerEvent(type:String, entry:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.entry = entry;
		}
	}
}