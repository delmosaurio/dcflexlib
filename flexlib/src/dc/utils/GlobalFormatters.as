package dc.utils
{
	import flash.globalization.CurrencyFormatter;
	import flash.globalization.NumberFormatter;
	
	import spark.formatters.DateTimeFormatter;
	
	public final class GlobalFormatters
	{
		
		public function GlobalFormatters()
		{
			throw new Error("This class can't be instanced.");
		}
		
		public static function DateTimeFormater(pattern:String="dd/MM/yyyy HH:mm") : DateTimeFormatter
		{
			var formater:DateTimeFormatter = new DateTimeFormatter();
			
			formater.dateTimePattern = pattern;
			
			return formater;
		}
		
		public static function DateFormater(pattern:String="dd/MM/yyyy") : DateTimeFormatter
		{
			var formater:DateTimeFormatter = new DateTimeFormatter();
			
			formater.dateTimePattern = pattern;
			
			return formater;
		}
		
		public static function CurrencyFormater(currencySymbol:String="$ ", fractionalDigits:int=2) : spark.formatters.CurrencyFormatter {
			var formater:spark.formatters.CurrencyFormatter = new spark.formatters.CurrencyFormatter();
			
			formater.useCurrencySymbol = true;
			formater.decimalSeparator = ",";
			formater.groupingSeparator = ".";
			formater.currencySymbol = currencySymbol;
			formater.fractionalDigits = fractionalDigits;
			return formater;
		}
		
		public static function GlobalCurrencyFormaterPesos() : CurrencyFormatter{
			var formater:CurrencyFormatter = new CurrencyFormatter("es-AR");
			
			formater.negativeCurrencyFormat = 14;
			formater.setCurrency(formater.currencyISOCode, "$ ");
			
			return formater;
			
		}
		
		public static function GlobalCurrencyFormaterDolar() : CurrencyFormatter{
			var formater:CurrencyFormatter = new CurrencyFormatter("en-US");
			
			formater.negativeCurrencyFormat = 14;
			formater.setCurrency(formater.currencyISOCode, "U$S ");
			
			return formater;
		}
		
		public static function NumberFormater(fractionalDigits:int=2) : NumberFormatter {
			var formater:NumberFormatter = new NumberFormatter("es-AR");
			
			formater.negativeNumberFormat = 0;
			formater.fractionalDigits = fractionalDigits;
			
			return formater;
		}
		
	}
}