package dc.components.gridClasses
{
	import flash.text.TextFormat;
	
	import spark.skins.spark.DefaultGridItemRenderer;
		
	public class EDefaultGridItemRenderer extends DefaultGridItemRenderer	{
		
		public function EDefaultGridItemRenderer() {
			super();
		}
				
		public function set textAlign(value:String) : void {
			
			setStyle("textAlign", value);
			styleChanged("textAlign");
		}
		
	}
}