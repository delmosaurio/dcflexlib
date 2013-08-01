package dc.utils
{
	import mx.utils.URLUtil;
	
	import org.as3commons.lang.ArrayUtils;
	import org.as3commons.lang.StringUtils;
	

	public class RequestUtils
	{
		public function RequestUtils() {
			throw new Error("This class con not be Instanstiate.");
		}
				
		public static function extractPathFragment(url:String) : String {
			//Asumo que url es una url valida
			
			var part:String = "";
			var end:int = url.search(/\?/);
			var init:int = url.search(/^!/);
			
			if (end==-1) {
				end = url.length-init;
			}
			
			part = url.substring( init, end );
						
			return part;
		}
		
		public static function extractParamsFragment(url:String) : String {
			//Asumo que url es una url valida
			
			var part:String = "";
			var init:int = url.search(/\?/);
			
			if (init==-1 || (init+1) == url.length ) {
				return "";
			}
			
			part = url.substring( init + 1 );
			
			return part;
		}
		
		public static function extractPath(path:String) : Array {
			//Asumo que url es una url valida
			var res:Array = new Array();
			
			var reg:RegExp = /(?<=\/)[A-z0-9]+/g;
			
			var result:Array = reg.exec(path); 
			var index:uint = 0;
			
			while (result != null) { 
				res[index++] = result[0] 
				result = reg.exec(path);
			} 
			
			return res;
		}
		
		public static function extractPathFromUrl(url:String) : Array {
			return RequestUtils.extractPath(
				RequestUtils.extractPathFragment( url )
			);
			
		}
		public static function mapView(path:String) : String {
			var res:String = "";
			
			var arr:Array = extractPath(path);
			
			if (arr.length == 0) return "";
			
			for (var i:int=0;i<(arr.length-1);i++) {
				
				if (i>0) { res += "."; }
				
				res += arr[i];
			}
			
			res += "::" + arr[arr.length-1];
			
			return res;
		}
		
		public static function mapAction(path:String) : String {
			return mapPath(path);
		}
		
		public static function mapPath(path:String) : String {
			var res:String = "";
			
			var arr:Array = extractPath(path);
			
			return ArrayUtils.toString(arr, ".");
		}
		
		public static function extractParams(url:String,delimiter:String="&") : Object {
			//Asumo que url es una url valida
			
			return URLUtil.stringToObject( extractParamsFragment(url), delimiter);
		}
		
		public static function extractPathForClass(classname:String, basePackage:String) : String {
			
			if (classname.indexOf(basePackage) != 0) 
				throw new Error("The base package or classname is wrong.");
			
			var p:String = classname.substring(basePackage.length + 1);
			
			p = p.substring(0, p.indexOf(".view::"));
			
			if (p=="") {
				p = "!";
			}
			
			return p;
		}
		
		public static function packageToPath(value:String) : String {
			var reg:RegExp = /\./g;
			
			return value.replace(reg, "/");
		}
		
		/***
		 *
		 * Valida una url
		 * 	
		 * !/module/View/?p1=0&p2=value
		 * !/module/View?p1=0&p2=value
		 * !/module/View
		 * !/module/View?
		 * !/module/View/
		 * !/module/View/?
		 * 
		 */
		public static function isValidUrl(url:String) : Boolean {
			if (url=="") return false;
			
			if ( url.search(/^!/) == -1 ) return false;
			
			return true;	
		}
		
	}
}