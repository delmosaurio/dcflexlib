package dc.components
{
	import dc.utils.FormatUtils;
	
	import flash.events.FocusEvent;
	
	public class CurrencyImput extends NumberInput
	{
		
		private var _currencySymbol:String = "$ ";
		
		public function CurrencyImput() {
			super();
		}
		
		public function set currencySymbol(value:String) : void {
			_currencySymbol = value;
			formatText();
		}
		
		public function get currencySymbol() : String {
			return _currencySymbol;
		}
		
		override protected function focusInHandler(event:FocusEvent):void {
			super.focusInHandler(event);
			
			this.text = valueNumber.toString().replace(".", ",");
			this.selectAll();
			
		}
		
		protected override function formatText() : void {
			try {
				this.toolTip = valueNumber.toString().replace(".", ",");
			} catch(err:Error) {}
			this.text = FormatUtils.formatCurrency(valueNumber, currencySymbol, this.fractionalDigits);
		}
		
	}
}