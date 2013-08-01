package dc.components
{
	
	import dc.utils.FormatUtils;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.operations.InsertTextOperation;
	import flashx.textLayout.operations.PasteOperation;
	
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import org.as3commons.lang.StringUtils;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	[Exclude(name="restrict", kind="property")]
	public class NumberInput extends DcTextInput
	{
		
		private var regex:RegExp;
		
		private var _value:Number = 0;
		
		private var _allowNegative:Boolean = true;
		
		private var _fractionalDigits:int = 2;
		
		public function NumberInput() {
			setStyle("textAlign", "right");
		}
				
		protected override function creationCompleteHandler(event:FlexEvent):void {
			this.formatText();
		}
		
		/**
		 * Specifies whether negative numbers are permitted.
		 * Valid values are true or false.
		 *
		 * @default true
		 */
		public function set allowNegative(value:Boolean):void {
			_allowNegative = value;
		}
		
		/**
		 * The maximum number of digits that can appear after the decimal
		 * separator.
		 * 
		 * @default 2
		 */
		public function set fractionalDigits(value:int):void {
			_fractionalDigits = value;
			formatText();
		}
		
		public function get fractionalDigits() : int {
			return _fractionalDigits;
		}
		
		[Bindable(event="propertyChange")]
		public function get valueNumber() : Number
		{
			return _value;
		}
		
		public function set valueNumber(value:Number):void
		{
			var oldValue:Number = _value;
			
			_value = value;
			
			dispatchChangeNumber(oldValue, _value);
			
			this.formatText();
		}
		
		protected function formatText() : void {
			try {
				this.toolTip = valueNumber.toString().replace(".", ",");
			} catch(err:Error) {}
			this.text = FormatUtils.formatNumber( valueNumber, this.fractionalDigits );
		}
		
		/**
		 *  @private
		 */
		override public function set restrict(value:String):void
		{
			throw(new Error("You are not allowed to change the restrict property of this class.  It is read-only."));
		}
		
		override protected function childrenCreated(): void {
			super.childrenCreated();
			
			//listen for the text change event
			addEventListener(TextOperationEvent.CHANGING, onTextChanging);
			addEventListener(TextOperationEvent.CHANGE, onTextChange);

		}
		
		override protected function focusInHandler(event:FocusEvent):void {
			super.focusInHandler(event);
			
			this.text = _value.toString().replace(".", ",");
			this.selectAll();
			
		}
		
		override protected function focusOutHandler(event:FocusEvent):void {
			
			this.formatText();
			super.focusOutHandler(event);
		}
		
		protected function onTextChange(event:TextOperationEvent):void {
			setValueFromStirng( text );
		}
		
		public function onTextChanging(event:TextOperationEvent):void {
			if (event.operation  is InsertTextOperation) {
				
				if (!isValidKeyCode()) {
					event.preventDefault();
					return;
				}
				if (lastKeyCode == Keyboard.NUMPAD_DECIMAL) {
					InsertTextOperation(event.operation).text = ",";
				}
				
				var textToBe:String = getTextToBe(event.operation);
				
				if (StringUtils.contains(textToBe, ",")) {
					if ( StringUtils.countMatches(textToBe, ",") > 1) {
						event.preventDefault();
					} else if ((textToBe.length-textToBe.indexOf(",")) > _fractionalDigits+1) {
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
		
		private function isValidKeyCode() : Boolean {
			
			if (lastKeyCode == Keyboard.COMMA || lastKeyCode == Keyboard.NUMPAD_DECIMAL) {
				return _fractionalDigits > 0;
			}
			
			if (lastKeyCode == Keyboard.MINUS) {
				return _allowNegative;
			}
			
			if (lastKeyCode >= Keyboard.NUMBER_0 && lastKeyCode <= Keyboard.NUMBER_9) {
				return true;
			}
			
			if (lastKeyCode >= Keyboard.NUMPAD_0 && lastKeyCode <= Keyboard.NUMPAD_9) {
				return true;
			}
			
			return false;
		}
		
		private function setValueFromStirng(value:String) : void
		{
			try {
				var oldValue:Number = _value;
				
				_value = parseFloat( value.replace(",", ".") );
				
				dispatchChangeNumber(oldValue, _value);
				
			} 
			catch(error:Error) {
				valueNumber = NaN;
			}
		}
		
		private function dispatchChangeNumber(oldValue:Number, value:Number, kind:String=PropertyChangeEventKind.UPDATE) : void {
			
			dispatchEvent(
				new PropertyChangeEvent(
					PropertyChangeEvent.PROPERTY_CHANGE,
					false,
					false,
					kind,
					"valueNumber",
					oldValue,
					value,
					this
				)
			);
			
		}
		
		// Rounds a target number to a specific number of decimal places.
		public static function roundToPrecision(numberVal:Number, precision:int = 0):Number
		{
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * numberVal) / decimalPlaces;
		}
		
	}
}