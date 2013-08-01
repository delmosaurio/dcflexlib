package dc.utils
{
	public class FormatUtils
	{
		public function FormatUtils() {
			throw new Error("This class con not be Instanstiate.");
		}
		
		public static function formatDate(value:Date,format:String="dd/MM/yyyy") : String {
			return GlobalFormatters.DateFormater(format).format(value);
			
		}
		
		public static function formatCurrency(value:Number,symbol:String="$ ", fractionalDigits:int=2) : String {
			return GlobalFormatters.CurrencyFormater(symbol, fractionalDigits).format(value);
		}
		
		public static function formatNumber(value:Number, fractionalDigits:int=2) : String {
			return GlobalFormatters.NumberFormater(fractionalDigits).formatNumber(value);
		}
		
	}
}