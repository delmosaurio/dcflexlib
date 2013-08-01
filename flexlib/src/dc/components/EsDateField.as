package dc.components
{
	import mx.controls.DateField;
	
	public class EsDateField extends DateField
	{
		
		private var _daysName:Array = ["D","L","M","M","J","V","S"];
		private var _monthsNames:Array = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
		
		public function EsDateField()
		{
			super();
			
			this.dayNames = _daysName;
			this.monthNames = _monthsNames;
			
			this.formatString = "DD/MM/YYYY";
			
			this.setStyle("fontFamily", "Arial");
			
		}
	}
}