package dc.mvc
{
	public class BaseViewModel implements IViewModel
	{
		
		private var _status:String = "";
		
		public function BaseViewModel() {
		}
		
		public function set status(value:String):void {
			_status = value;
		}
		
		[Bindable]
		public function get status():String {
			return _status;
		}
	}
}