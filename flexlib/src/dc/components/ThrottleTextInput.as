package dc.components
{
	import dc.events.ThrottleEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	[Event(name="textChangeThrottle", type="dc.events.ThrottleEvent")]
	public class ThrottleTextInput extends TextInput
	{
		
		private var _throttle:int = 0;
		
		private var _timer:Timer = new Timer(0);
		
		private var _lastEvent:TextOperationEvent;
		
		public function ThrottleTextInput() {
			super();
			
			this.addEventListener(TextOperationEvent.CHANGE, OnTextChange);
			_timer.addEventListener(TimerEvent.TIMER, OnTimerPulse);
		}
		
		protected function OnTimerPulse(event:TimerEvent):void {
			_timer.stop();
			
			dispatchThrottle();
		}
		
		protected function OnTextChange(event:TextOperationEvent):void {
			_lastEvent = event;
			
			if (_throttle==0)  { dispatchThrottle(); }
			
			_timer.stop();
			_timer.reset();
			_timer.start();
		}
		
		private function dispatchThrottle():void {
			var e:ThrottleEvent = new ThrottleEvent( _lastEvent, _throttle);
			this.dispatchEvent(e);
		}
		
		public function get throttle():int {
			return _throttle;
		}

		public function set throttle(value:int):void {
			_throttle = value;
			_timer.delay = _throttle;
		}

	}
}