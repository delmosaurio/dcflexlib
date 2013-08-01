package dc.components.dialogs
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IFlexModuleFactory;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	public class MessageBoxManager
	{
		private static var _instance:MessageBoxManager;
				
		public function MessageBoxManager() {
			
			if (_instance!=null) {
				throw new Error("Singleton - Can't Instanstiate");
			}
			
			_instance = this;
		}
		
		public static function getInstance():MessageBoxManager {
			if (_instance == null)
				_instance = new MessageBoxManager();
			
			return _instance;
		}
		
		/* Manager */
		
		public function show(
			text:String = "", title:String = "",
			flags:uint = 0x4 /* Alert.OK */, 
			parent:Sprite = null, 
			closeHandler:Function = null,
			iconClass:Class = null, 
			defaultButtonFlag:uint = 0x4 /* Alert.OK */,
			moduleFactory:IFlexModuleFactory = null
		) : void 
		{
			
			Alert.show( 
				text, title, 
				flags,
				parent, 
				closeHandler, 
				iconClass, 
				defaultButtonFlag,
				moduleFactory
			);
		}
		
		public function question(
			text:String = ""
			, title:String = ""
			  , yesHandler:Function=null
				, noHandler:Function=null
		) : void {
			
			Alert.show(text, title, Alert.YES | Alert.NO, null, 
				function (ce:CloseEvent) : void {
					if (ce.detail == Alert.YES) {
						if (yesHandler!=null) { yesHandler(ce); }
					} else if (ce.detail == Alert.NO) {
						if (noHandler!=null) { noHandler(ce); }
					}
				}
			);
			
		}
		
		public function box(
			message:String = "", 
			title:String = "", 
			delay:int=-1,
			closeHandler:Function = null ) : MessageBox 
		{
			return showTarget( new MessageBox(message, title), delay, closeHandler) as MessageBox;
			
		}
		
		public function success(
			message:String = "", 
			title:String = "", 
			delay:int=2.5,
			closeHandler:Function = null ) : SuccessMessageBox 
		{
			return showTarget( new SuccessMessageBox(message, title), delay, closeHandler) as SuccessMessageBox;
			
		}
		
		public function warning(
			message:String = "", 
			title:String = "", 
			delay:int=2.5,
			closeHandler:Function = null ) : WarningMessageBox 
		{
			return showTarget( new WarningMessageBox(message, title), delay, closeHandler) as WarningMessageBox;
		}
		
		public function error(
			message:String = "", 
			title:String = "", 
			delay:int=2.5,
			closeHandler:Function = null ) : ErrorMessageBox 
		{
			return showTarget( new ErrorMessageBox(message, title), delay, closeHandler) as ErrorMessageBox;
			
		}
		
		private function showTarget(target:MessageBox, delay:int=-1,closeHandler:Function = null ) : MessageBox {
			
			var app:Object = FlexGlobals.topLevelApplication;
			PopUpManager.addPopUp( target, app as DisplayObject, false);
			PopUpManager.centerPopUp( target );
			PopUpManager.bringToFront( target );
			
			target.y = 5;
			
			Tweener.addTween( target, { 
				alpha:0, 
				time:.7, 
				delay:delay,
				onComplete:function () : void { PopUpManager.removePopUp( target ); }
			});
			
			target.addEventListener(
				MouseEvent.CLICK, 
				function (me:MouseEvent):void { 
					Tweener.removeTweens(target);
					PopUpManager.removePopUp( target );
					me.stopPropagation();
				}
			);
			
			
			return target;
			
		}
		
		/* Manager */
		
	}
}