package dc.components.supportClasses
{
	import dc.core.GlobalExceptionHandler;
	import dc.utils.GlobalFormatters;
	
	import flash.globalization.CurrencyFormatter;
	
	import spark.components.gridClasses.GridColumn;
	
	public class DefaultLabelFunction implements ILabelFunctionAdapter
	{
		private var _defaultValue:String = "-";
		
		private var _currencySymbol:String = "$ ";
		
		public function DefaultLabelFunction() {
		}
		
		public function get defaultValue() : String {
			return _defaultValue;
		}
		
		public function set defaultValue(value:String) : void {
			_defaultValue = value;
		}
		
		public function get currencySymbol() : String {
			return _currencySymbol;
		}
		
		public function set currencySymbol(value:String) : void {
			_currencySymbol = value;
		}
		
		private function isOk(item:Object, column:GridColumn) : Boolean {
			if (
				   !column 
				|| !item 
				|| !column.dataField 
				|| column.dataField==""
				|| !item.hasOwnProperty(column.dataField)) return false;
			
			return true;
		}
		
		public function bool_labelFunction(item:Object, column:GridColumn):String {
			
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Boolean = item[column.dataField] as Boolean;
			
			return target ? "Si" : "No";
		}
		
		public function date_labelFunction(item:Object, column:GridColumn):String {
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Date = item[column.dataField] as Date;
			
			if (!target) return _defaultValue;
			
			return GlobalFormatters.DateFormater().format( target );
		}
		
		public function time_labelFunction(item:Object, column:GridColumn):String {
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Date = item[column.dataField] as Date;
			
			if (!target) return _defaultValue;
			
			return GlobalFormatters.DateTimeFormater("HH:mm:ss").format( target );
		}
		
		public function datetime_labelFunction(item:Object, column:GridColumn):String {
			
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Date = item[column.dataField] as Date;
			
			if (!target) return _defaultValue;
			
			return GlobalFormatters.DateTimeFormater().format( target );
		}
		
		public function number_labelFunction(item:Object, column:GridColumn):String {
			
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Number = item[column.dataField] as Number;
			
			if (isNaN(target)) return _defaultValue;
			
			return GlobalFormatters.NumberFormater().formatNumber( target );
		}
		
		public function int_labelFunction(item:Object, column:GridColumn):String {
			if (!isOk(item, column)) return _defaultValue;
			
			var target:int = item[column.dataField] as int;
			
			if (isNaN(target)) return _defaultValue;
			
			return parseInt(target.toString()).toString();
		}
		
		public function currency_labelFunction(item:Object, column:GridColumn):String {
			if (!isOk(item, column)) return _defaultValue;
			
			var target:Number = item[column.dataField] as Number;
			
			if (isNaN(target)) return _defaultValue;
		
			return GlobalFormatters.CurrencyFormater(currencySymbol).format( target );
		}
		
		public function getTextAlign(dataType:String="none") : String {
			switch(dataType) {
				
				case "bool": 
				case "date": 
				case "time": 
				case "datetime": return "center";
				case "number": 
				case "int": 
				case "currency": return "right";
					
				case "none":
				default: return "left";
			}
		}
	}
}