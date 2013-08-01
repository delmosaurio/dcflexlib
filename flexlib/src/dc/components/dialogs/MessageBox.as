package dc.components.dialogs
{
	
	import caurina.transitions.Tweener;
	
	import dc.skins.MessageBoxSkin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;

	[Style(name="padding", inherit="no", type="Number", format="Number")]
	[Style(name="borderColor", inherit="no", type="uint", format="Color" )]
	[Style(name="borderWeight", inherit="no", type="Number", format="Number")]
	[Style(name="borderVisible", inherit="no", type="Boolean", format="Boolean")]
	[Style(name="cornerRadius", inherit="no", type="Number", format="Number")]
	[Style(name="icon", inherit="no", type="Class", format="EmbeddedFile")]
	public class MessageBox extends SkinnableContainer
	{
		[SkinPart(required="true")]
		public var labelDisplay:Label;
		
		[Bindable] public var message:String="";
		
		[Bindable] public var title:String="";
				
		public function MessageBox(msg:String="",title:String="") {
			super();
			
			if (!getStyle("backgroundColor")) {
				setStyle("backgroundColor", "#FFFFFF");	
			}
			
			setStyle("skinClass", MessageBoxSkin);
			
			this.message = msg;
			this.title = title;
		}
		
		
	}
}