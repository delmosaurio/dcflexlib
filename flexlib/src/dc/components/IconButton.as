package dc.components
{
	import dc.skins.IconButtonSkin;
	
	import spark.components.Button;
	
	public class IconButton extends Button
	{
		
		[SkinPart(type="uint", required="false")]
		public var padding:uint;
		
		public function IconButton()
		{
			super();
			
			setStyle("skinClass", dc.skins.IconButtonSkin);
		}
				
	}
}