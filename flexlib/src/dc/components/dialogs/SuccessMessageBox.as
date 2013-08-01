package dc.components.dialogs
{
	

	public class SuccessMessageBox extends MessageBox
	{
		//TODO: Fix the css problem
		[Embed(source="dc/resources/success_16x16.png")]
		private var ic:Class;
		
		public function SuccessMessageBox(msg:String="",title:String="") {
			super(msg,title);
			setStyle("backgroundColor", "#DFF2BF");
			setStyle("color", "#4F8A10");
			setStyle("icon", ic);
		}

	}
}