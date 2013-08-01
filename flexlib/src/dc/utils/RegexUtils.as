package dc.utils
{
	public final class RegexUtils
	{
		//EXTRACT NUMBER
		///(?<=^|\$)([+-]?([1-9][0-9]{0,2}(\.?\d{3})+|\d{0,100}+)(,[0-9]+)?)(?=%|$)/g
		
		public function RegexUtils() {
			throw new Error("This class con not be Instanstiate.");
		}
		
		public static function regExEscape(text:String,width:String="\\$&") : String {
			
			return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, width);
			
		}
		
	}
}