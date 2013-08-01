package dc.utils
{
	import mx.utils.ObjectUtil;

	public final class DevUtils
	{
		public function DevUtils() {
			throw new Error("UtilClass - Can't Instanstiate");
		}
		
		public static function traceObjectProperties(item:Object, itemName:String="res") : void
		{
			trace( DevUtils.objectProperties( item, itemName) );	
		}
		
		public static function objectProperties(item:Object, itemName:String) : String
		{
			var infoItem:Object = ObjectUtil.getClassInfo(item);
			
			var res:String = "";
			
			for each(var p:Object in infoItem.properties) {
				res += itemName + "." + p.localName.toString() + " = null; //" + ObjectUtil.getClassInfo(item[p.localName]).name + "\n";
			}
			
			return res;
		}
	}
}