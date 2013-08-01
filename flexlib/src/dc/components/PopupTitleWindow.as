package dc.components
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.TitleWindow;
	
	public class PopupTitleWindow extends TitleWindow
	{
		
		private var _cancelButton:Button;

		private var _acceptButton:Button;
		
		public function PopupTitleWindow()
		{
			super();
			this.addEventListener(CloseEvent.CLOSE, closeHandler);
			
			ChangeWatcher.watch(this, "y", yChangeHandler)
		}
		
		private function yChangeHandler(event:Event):void {
			if (this.y <=0) {
				this.y = 1;
			}
		}
		
		override protected function closeButton_clickHandler(event:MouseEvent):void {
			closeCancel();
		}
		
		protected function closeHandler(event:CloseEvent):void {
			PopUpManager.removePopUp( this );
		}
		
		public function closeOk() : void {
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
			ce.detail = Alert.OK;
			this.dispatchEvent( ce );
		}
		
		public function closeCancel() : void {
			var ce:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
			ce.detail = Alert.CANCEL;
			this.dispatchEvent( ce );
		}
		
		public function get cancelButton() : Button {
			return _cancelButton;
		}
		
		public function set cancelButton(value:Button) : void {
			_cancelButton = value;
			if (_cancelButton) {
				_cancelButton.addEventListener( MouseEvent.CLICK, calcelButtonHandler);
			}
		}
		
		protected function calcelButtonHandler(event:MouseEvent):void {
			closeCancel();
		}
		
		public function get acceptButton() : Button {
			return _acceptButton;
		}
		
		public function set acceptButton(value:Button) : void {
			_acceptButton = value;
			if (_acceptButton) {
				_acceptButton.addEventListener( MouseEvent.CLICK, acceptButtonHandler);
			}
		}
		
		protected function acceptButtonHandler(event:MouseEvent):void {
			this.busy();
		}
		
		public function busy() : void {
			this.enabled = false;
		}
		
		public function available() : void {
			this.enabled = true;
		}
		
		public var validateFunction:Function = null;
		
		public function validate() : Boolean {
			if (validateFunction!=null) {
				return validateFunction( this );
			}
			
			return true;
		}
		
	}
}