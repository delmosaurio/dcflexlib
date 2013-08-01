package dc.mvc
{
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Method;

	public class RequestAction
	{
		
		public var action:String = "";
		
		public var type:String = "";
		
		public var title:String = "";
				
		public var rule:String = "";
		
		public var flag:* = "";
		
		public var persist:Boolean = false;
		
		public var method:Method = null;
		
		public function RequestAction(method:Method=null, md:Metadata=null) {
			
			if (!method) return;
			
			this.method = method;
			
			var a:MetadataArgument = md.getArgument("action");
			var ty:MetadataArgument = md.getArgument("type");
			var t:MetadataArgument = md.getArgument("title");
			var p:MetadataArgument = md.getArgument("persist");
			var r:MetadataArgument = md.getArgument("rule");
			var f:MetadataArgument = md.getArgument("flag");
			
			if (a) { this.action = a.value; }
			if (ty) { this.type = ty.value; }
			if (t) { this.title = t.value; }
			if (p) { this.persist = p.value=="true"; }
			if (r) { this.rule = r.value; }
			if (f) { this.flag = f.value; }
			
		}
		
		public function getPath() : String {
			return StringUtils.substringBeforeLast(action, ".");
		}
		
		public function toString() : String {
			
			return StringUtils.substitute(
				"{0} [ action='{1}' type='{2}' title='{3}']"
				, "RequestAction"
				, action
				, type
				, title
			);
		}
		
	}
}