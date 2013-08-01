package dc.components
{
	import dc.utils.FormatUtils;
	import dc.utils.GlobalFormatters;
	
	import flash.events.FocusEvent;

	public class PercentInput extends NumberInput
	{
		public function PercentInput() {
			super();
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
			this.text = "% " + FormatUtils.formatNumber(valueNumber, this.fractionalDigits);
		}
		
	}
}