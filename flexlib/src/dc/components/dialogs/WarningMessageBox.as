package dc.components.dialogs
{
	public class WarningMessageBox extends MessageBox
	{
		//TODO: Fix the css problem
		[Embed(source="dc/resources/error_16x16.png")]
		private var ic:Class;
		
		public function WarningMessageBox(msg:String="",title:String="") 
		{
			super(msg,title);
			setStyle("backgroundColor", "#FEEFB3");
			setStyle("color", "#9F6000");
			setStyle("icon", ic);
		}
	}
}