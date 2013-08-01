package dc.events
{
	import flash.events.Event;
	
	import org.as3commons.lang.StringUtils;
	
	public class RequestEvent extends Event
	{
		public static const REQUEST:String = "request";
		
		public static const INVALID_REQUEST:String = "invalidRequest";
		
		public var fromApp:Boolean = false;
		
		public var isPostBack:Boolean = false;
		
		public var url:String = null;
		
		public var isBack:Boolean=false;
		
		public var isForward:Boolean=false;
		
		public function RequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
				
	}
}