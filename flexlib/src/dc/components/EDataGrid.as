package dc.components
{
	import dc.components.supportClasses.DefaultLabelFunction;
	import dc.components.supportClasses.ILabelFunctionAdapter;
	
	import spark.components.DataGrid;
	
	public class EDataGrid extends DataGrid {
		
		private var _labelFunctionAdapter:ILabelFunctionAdapter;
		
		public function EDataGrid() {
			super();
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
		
	}
}