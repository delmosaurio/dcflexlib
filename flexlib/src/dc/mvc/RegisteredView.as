package dc.mvc
{
	import dc.utils.RequestUtils;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Type;

	public class RegisteredView {
	
		
		public var path:String = "";
		
		public var viewName:String = "";
		
		private var _basePackage:String = "modules";
		
		private var _alias:ArrayCollection;
		
		public var viewClass:Class;
		
		public function RegisteredView() {
		}
		
		public function create(cl:Class=null, basePackage:String="modules") : Boolean {
			
			_basePackage = basePackage;
			
			viewClass = cl;
			
			var type:Type = Type.forClass(cl);
			
			path = RequestUtils.extractPathForClass(type.fullName, _basePackage);
			
			viewName = type.name;
			
			createAlias(cl);
			
			return true;
		}
	
		public function getAbsolutePath() : String {
			return "!/" + RequestUtils.packageToPath(path) + "/" + viewName + "/?";
		}
		
		private function createAlias(cl:Class) : void {
			
			var type:Type = Type.forClass( cl );
			var rv:Array = type.getMetadata("requestview");
			
			if (!rv || rv.length == 0) return;
			
			for each(var md:Metadata in rv) {
				
				var arg:MetadataArgument = md.getArgument("view");
				
				if (!arg || arg.value=="") continue;
				
				if (arg.value.indexOf(",") >=0) {
					
					var arr:Array = arg.value.split(",");
					for each(var v:String in arr) {
						addAlias(v);
					}
					
				} else {
					addAlias( arg.value );
				}
				
			}
			
		}
		
		private function addAlias(value:String) : void {
			if (value=="" || alias.getItemIndex(value) != -1) return;
			
			this.alias.addItem( value );
		}
		
		public function get alias() : ArrayCollection {
			if (_alias==null) 
				_alias = new ArrayCollection();
			
			return _alias;
		}
		
		public function getPathName() : String {
			return path + "::" + viewName;
		}
		
		public function getNames(full:Boolean=false) : ArrayCollection {
			var res:ArrayCollection = new ArrayCollection();
			
			var vn:String = full ? path + "::" + viewName : viewName;
			
			addUniqueToCollection(vn, res);
			
			for each(var a:String in alias) {
				var an:String = full ? path + "::" + a : a;
				addUniqueToCollection(an, res);
			}
			
			return res;
		}
		
		public function match(fullname:String) : Boolean {
			
			for each(var n:String in getNames(true)) {
				if (fullname.toLowerCase() == n.toLowerCase())
					return true;
			}
			
			return false;
		}
		
		public function toString():String{
			return getAbsolutePath();
		}
		
		/*TODO: Utils*/
		private function addUniqueToCollection(value:String, collection:ArrayCollection) : void {
			if (value=="" || collection.getItemIndex(value) != -1) return;
			
			collection.addItem( value );
		}
	}
}