package dc.mvc
{
	public class RequestContext
	{
		
		public var type:String = "";
		
		public var target:*=null;
		
		public var action:RequestAction=null;
		
		public var actionName:String="";
		
		public function RequestContext(type:String="none") {
			this.type = type;
			
		}
		
		public function toString():String {
			return "[type=" + type + ", actionName= " + actionName + "]"
		}
		
	}
}