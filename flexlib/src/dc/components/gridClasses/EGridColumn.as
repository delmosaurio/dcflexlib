package dc.components.gridClasses
{
	import dc.components.supportClasses.DefaultLabelFunction;
	import dc.components.supportClasses.ILabelFunctionAdapter;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	
	import spark.components.gridClasses.GridColumn;
	
	
	public class EGridColumn extends GridColumn
	{
		
		private var _buttons:IList;
		
		private var _dataType:String="none";
		
		private var _labelFunctionAdapter:ILabelFunctionAdapter;
		
		
		
		public function EGridColumn(columnName:String=null) {
			super(columnName);
		}
		
		public function get buttons() : IList {
			if (_buttons==null) {
				_buttons = new ArrayList()
			}
			
			return _buttons;
		}
		
		public function set buttons(value:IList) : void {
			_buttons = value;
			
			this.itemRenderer = new ClassFactory(EItemRenderer);
		}
		
		[Inspectable(enumeration="none,bool,date,time,datetime,number,int,currency,percent", defaultValue="none")]
		[Bindable]
		public function get dataType() : String {
			return _dataType;
		}
		
		public function set dataType(value:String) : void {
			_dataType = value;
			updateUI();
		}
		
		private function updateUI():void {
			
			//Define la labelFunction dependiedo de dataType seteado
			if (_dataType=="none") {
				this.labelFunction = null;
				return;
			}
			
			this.labelFunction = delegateLabelFunction();
			
			updateAlign();
		}
		
		private function updateAlign():void {
			var f:ClassFactory = new ClassFactory(EDefaultGridItemRenderer);
			f.properties = {textAlign: this.labelFunctionAdapter.getTextAlign(this.dataType) };
			this.itemRenderer = f;
			
		}
		
		/* laebelFunctions */
		
		private function delegateLabelFunction() : Function {
			
			var lfa:ILabelFunctionAdapter = this.labelFunctionAdapter;
			
			switch(_dataType) {
				
				case "bool": return lfa.bool_labelFunction;
				case "date": return lfa.date_labelFunction;
				case "time": return lfa.time_labelFunction;
				case "datetime": return lfa.datetime_labelFunction;
				case "percent": //<-TODO
				case "number": return lfa.number_labelFunction;
				case "int": return lfa.int_labelFunction;
				case "currency": return lfa.currency_labelFunction;
					
				case "none":
					default: return null;
			}
			
		}
		
		public function get currencySymbol() : String {
			return labelFunctionAdapter.currencySymbol;
		}
		
		public function set currencySymbol(value:String) : void {
			labelFunctionAdapter.currencySymbol = value;
		}
		
		[Bindable]
		public function get labelFunctionAdapter() : ILabelFunctionAdapter {
			if (_labelFunctionAdapter==null) {
				_labelFunctionAdapter = new DefaultLabelFunction();
			}
			
			return _labelFunctionAdapter;
		}
		
		public function set labelFunctionAdapter(value:ILabelFunctionAdapter) : void {
			_labelFunctionAdapter = value;
		}
		
		/* laebelFunctions */
			
	}
}