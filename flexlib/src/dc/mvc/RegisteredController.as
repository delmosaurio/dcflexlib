package dc.mvc
{
	import dc.dev.Console;
	
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	public class RegisteredController
	{
		
		private var _actions:Dictionary;
		
		public var controllerName:String = "";
		
		public var controllerClass:Class;
		
		private var logger:Console = Console.getInstance();
		
		public function RegisteredController() {
		}
		
		public function create(cl:Class=null) : Boolean {
			
			var type:Type = Type.forClass(cl);
			
			controllerName = type.fullName;
			
			controllerClass = cl;
			
			var rv:Array = type.methods;
			
			if (rv.length == 0) {
				//logger.log("the type " + type.fullName + " has not methods");
			}
			
			for (var i:int = 0; i < rv.length; i++) {
				
				var m:Method = rv[i];
				
				if (m.hasMetadata("requestaction")) {
					
					var ra:Array = m.getMetadata("requestaction");
					
					for each(var md:Metadata in ra) {
						var a:RequestAction = new RequestAction(m, md);
						
						if (a.action == "") return false;
						
						actions[a.action.toLowerCase()] = a; 
						
						logger.log(controllerName + " " + a.action.toLowerCase()); 
						
					}
					
				} else {
					//logger.log("the method " + m.name + " has not metadata requestaction. Metadata: (" + ArrayUtils.toString(m.metadata) + ")");
				}
			}
			
			return true;
		}
		
		public function get actions() : Dictionary {
			if (_actions==null)
				_actions = new Dictionary();
			
			return _actions;
		}
			
		public function hasAction(ac:String) : Boolean {
			
			for (var a:String in actions) {
				
				if (a.toLowerCase() == ac.toLowerCase()) {
					return true;
				}
			}
			
			return false;
		}
		
		public function getAction(name:String) : RequestAction {
			return actions[name.toLowerCase()];
		}
		
		public function toString() : String {
			
			var acs:Array = new Array();
			
			for (var a:String in actions) {
				acs.push(a);
			}
			
			return "[controllerName=" + controllerName + ", actions=(" + ArrayUtils.toString(acs) + ")]"
		}
		
	}
}