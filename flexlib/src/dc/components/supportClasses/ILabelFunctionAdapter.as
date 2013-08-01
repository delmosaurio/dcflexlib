package dc.components.supportClasses
{
	import spark.components.gridClasses.GridColumn;

	public interface ILabelFunctionAdapter {
		
		//bool
		function bool_labelFunction(item:Object,column:GridColumn) : String;
		
		//date
		function date_labelFunction(item:Object,column:GridColumn) : String;
		
		//time
		function time_labelFunction(item:Object,column:GridColumn) : String;
		
		//datetime
		function datetime_labelFunction(item:Object,column:GridColumn) : String;
		
		//number
		function number_labelFunction(item:Object,column:GridColumn) : String;
		
		//int
		function int_labelFunction(item:Object,column:GridColumn) : String;
		
		//currency
		function currency_labelFunction(item:Object,column:GridColumn) : String;
		
		function getTextAlign(dataType:String="none") : String;
		
		function get defaultValue() : String;
		
		function set defaultValue(value:String) : void;
		
		function get currencySymbol() : String;
		
		function set currencySymbol(value:String) : void;
		
		
	}
}