package dc.components
{
	import dc.core.GlobalExceptionHandler;
	import dc.dev.Console;
	import dc.events.RequestEvent;
	import dc.mvc.RequestActionManager;
	import dc.utils.RequestUtils;
	
	import mx.events.BrowserChangeEvent;
	import mx.events.FlexEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.managers.ISystemManager;
	
	import spark.components.Application;
	
	public class DcApplication extends Application
	{
		
		public var logger:Console = Console.getInstance(); 
		
		public function DcApplication() {
			super();
		}
		
		protected function initGlobalExceptions(sm:ISystemManager,handler:Function=null) : void {
			
			GlobalExceptionHandler.init(sm,handler);
			var gl:GlobalExceptionHandler = new GlobalExceptionHandler();
			
		}
			
				
	}
}
