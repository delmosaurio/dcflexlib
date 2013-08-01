package dc.components
{
	import dc.events.RequestActionEvent;
	import dc.mvc.RequestController;
	
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	
	import org.as3commons.reflect.Type;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	public class RequestView extends SkinnableContainer	{
				
		private var _viewData:Dictionary;
		
		private var _controller:RequestController;
		
		public function RequestView() {
			super();
			
			//FOR DEBUGGIN
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}				
		
		public function get controller() : RequestController {
			return _controller;
		}
		
		public function set controller(value:RequestController) : void {
			_controller = value;
		}
		
		public function get viewData() : Dictionary {
			if (controller != null) {
				return controller.getViewData(this);
			}
			
			if (_viewData==null) {
				_viewData = new Dictionary();
			}
			
			return _viewData;
		}
		
		private function creationCompleteHandler(event:FlexEvent):void {
			/*
			var type:Type = Type.forInstance( this );
			var lbl:Label = new Label();
			lbl.text = type.fullName;
			this.addElement( lbl );
			*/
		}
		
		public function onLoad(event:RequestActionEvent) : void {
			
		}
				
	}
}