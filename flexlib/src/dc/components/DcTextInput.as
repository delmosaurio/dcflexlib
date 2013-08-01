package dc.components
{
	import dc.utils.GlobalFormatters;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.operations.CutOperation;
	import flashx.textLayout.operations.DeleteTextOperation;
	import flashx.textLayout.operations.FlowOperation;
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	import flashx.textLayout.operations.SplitParagraphOperation;
	import flashx.textLayout.operations.UndoOperation;
	
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.INamespaceOwner;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	public class DcTextInput extends TextInput
	{
		
		private var _lastKeyCode:uint=0;
		
		public var numberRegex:RegExp = /^[+-]?([1-9][0-9]{0,2}(\.?\d{3})+|\d{0,100}+)(,[0-9]+)?$/;
		
		private var _valueNumber:Number=0;
		
		private var _editing:Boolean = false;
		
		public function DcTextInput()
		{
			super();
			
			//addEventListener(TextOperationEvent.CHANGING, onTextChanging);
			//addEventListener(TextOperationEvent.CHANGE, onTextChange);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		protected function creationCompleteHandler(event:FlexEvent):void {
			
		}
		
		private function onFocusIn(event:FocusEvent):void {
			
		}
		
		private function onFocusOut(event:FocusEvent):void {
			this.text = GlobalFormatters.GlobalCurrencyFormaterPesos().format( _valueNumber, true );
		}
		
		private function onTextChange(event:TextOperationEvent):void  {
			
			if (event.operation  is PasteOperation) {
				this.text = StringUtils.remove(this.text, "\\.");
			}
			
			_valueNumber = parseFloat( this.text.replace(",", ".") );
		}
		
		private function onTextChanging(event:TextOperationEvent):void
		{
			if (event.operation  is InsertTextOperation) {
				
				//Controlamos el key code
				if (lastKeyCode == Keyboard.NUMPAD_DECIMAL) {
					InsertTextOperation(event.operation).text = ",";
				} else if (lastKeyCode != 188 && (lastKeyCode < 48 || (lastKeyCode > 57 && lastKeyCode < 96 ) || lastKeyCode > 105)) {
					event.preventDefault();
					return;
				}
				
				var textToBe:String = getTextToBe(event.operation);
											
				if (StringUtils.contains(textToBe, ",")) {
					if ( StringUtils.countMatches(textToBe, ",") > 1) {
						event.preventDefault();
					} else if ((textToBe.length-textToBe.indexOf(",")) > 3) {
						event.preventDefault();
					}
				}
				
			}
			
			if (event.operation  is PasteOperation) {
				textToBe = getTextToBe(event.operation);
				if (!numberRegex.test(textToBe)) {
					event.preventDefault();
				}
			}
		}
		
		override protected function focusInHandler(event:FocusEvent):void {
			super.focusInHandler(event);
			_editing = true;
		}
		
		override protected function focusOutHandler(event:FocusEvent):void {
			super.focusOutHandler(event);
			_editing = false;
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			_lastKeyCode = event.keyCode;
			
			super.keyDownHandler(event);
		}
		
		public function get lastKeyCode() : uint {
			return _lastKeyCode;
		}
		
		public function get editing() : Boolean {
			return _editing;
		}
		
		protected function getTextToBe(operation:FlowOperation) : String {
			
			var to:String = "";
			var textToBe:String = "";
			
			if (operation  is InsertTextOperation) {
				to = InsertTextOperation(operation).text;
			} else if (operation  is PasteOperation) {
				var po:PasteOperation = PasteOperation(operation);
				to = po.textScrap.textFlow.getText();
			}
						
			if (selectionActivePosition==selectionAnchorPosition) {
				if (selectionActivePosition>0) {
					textToBe += text.substr(0, selectionActivePosition)
					textToBe += to;
					textToBe += text.substr(selectionActivePosition)
				} else {
					textToBe = to + text;
				}
			} else if (selectionActivePosition<selectionAnchorPosition){
				//selected from the left
				
				textToBe += text.substr(0, selectionActivePosition)
				textToBe += to;
				textToBe += text.substr(selectionAnchorPosition)
				
			} else {
				//selected from the rigth
				textToBe += text.substr(0, selectionAnchorPosition)
				textToBe += to;
				textToBe += text.substr(selectionActivePosition)
			}
			
			return textToBe;
		}
		
	}
}