package dc.components
{
	import spark.components.Label;
	
	public class LabelLink extends Label
	{
		public function LabelLink() {
			super();
			
			setStyle("textDecoration", "underline");
			setStyle("color", "blue");
			buttonMode = true;
			
		}
	}
}