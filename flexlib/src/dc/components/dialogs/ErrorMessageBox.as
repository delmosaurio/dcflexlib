package dc.components.dialogs
{
	public class ErrorMessageBox extends MessageBox
	{
		//TODO: Fix the css problem
		[Embed(source="dc/resources/error_16x16.png")]
		private var ic:Class;
		
		public function ErrorMessageBox(msg:String="",title:String="") 
		{
			super(msg,title);
			setStyle("backgroundColor", "#D8000C");
			setStyle("color", "#FFBABA");
			setStyle("icon", ic);
			
		}
	}
}