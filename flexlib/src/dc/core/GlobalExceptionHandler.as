package dc.core
{
	import flash.display.LoaderInfo;
	import flash.events.UncaughtErrorEvent;
	
	import mx.managers.ISystemManager;
	
	[Mixin]
	[DefaultProperty("handlerActions")]
	public class GlobalExceptionHandler
	{
		
		private static var loaderInfo:LoaderInfo;
		
		private static var stageLoaderInfo:LoaderInfo;
		
		[ArrayElementType("com.adobe.ac.logging.GlobalExceptionHandlerAction")]
		public var handlerActions:Array;
		
		public var preventDefault:Boolean=true;
		
		private static var _sm:ISystemManager;
		
		private static var _handler:Function;
		
		/***
		 * 
		 * @param handler (event:UncaughtErrorEvent)
		 * 
		 */
		public static function init(sm:ISystemManager,handler:Function=null):void {
			_sm = sm;
			
			loaderInfo = sm.loaderInfo;
			//stageLoaderInfo = sm.stage.loaderInfo;
						
			sm.isTopLevel();
			
			_handler = handler;
			
		}
		
		public function GlobalExceptionHandler() {
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			//stageLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (_handler!=null) {
				_handler(event);
				return;
			}
			
			if (preventDefault) {
				event.preventDefault();
			}
		}
	}
}