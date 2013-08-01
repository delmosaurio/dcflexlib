package dc.rpc
{
	import dc.events.ProxyEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	[Event(name="proxyError", type="dc.events.ProxyEvent")]
	[Event(name="callBegin", type="dc.events.ProxyEvent")]
	[Event(name="callComplete", type="dc.events.ProxyEvent")]
	public class ProxyBase  implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
		
		public function ProxyBase()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		/* IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}
		
		/* IEventDispatcher */
		
		protected function resultServiceOk ( rs:* ) : Boolean {
			try {
				if (!rs) return reportNullRs();
				
				var st:Object = rs["StatusCode"];
				
				if (st==null)  return reportIsNotRs();
				
				if (st < 200 || st > 400) return reportRsError(rs);
				
				return true;
			}
			catch (err:Error) {
				return reportInternalError(err);
			}
			
			return false;
		}
		
		private function reportNullRs() : Boolean {
			return returnWithError("El retorno de servicio es nulo.");
		}
		
		private function reportIsNotRs() : Boolean {
			return returnWithError("El objeto de retorno no es valido.");
		}
		
		private function reportRsError(rs:*) : Boolean {
			var msj:String = rs["StatusMessage"];
			
			return returnWithError(msj);
		}
		
		private function reportInternalError(err:Error) : Boolean {
			return returnWithError(err.message, err.errorID.toString());
		}
		
		protected function dispatchInternalError(err:Error) : void {
			var event:ProxyEvent = new ProxyEvent( ProxyEvent.ERROR );
			
			event.messageId = err.errorID.toString()
			event.message = err.message;
			
			dispatchEvent( event );
		}
		
		private function returnWithError(message:String, messageId:String="NaN") : Boolean {
			var event:ProxyEvent = new ProxyEvent( ProxyEvent.ERROR );
			
			event.messageId = messageId;
			event.message = message;
			
			dispatchEvent( event );
			
			return false;
		}
		
		protected function onFaultEvent(event:FaultEvent) : void {
			
			var ee:ProxyEvent = new ProxyEvent( ProxyEvent.ERROR );
			
			ee.messageId = event.messageId;
			ee.message = event.message.toString();
			
			dispatchEvent( ee );
		}
		
		protected function dispatchCallBeginEvent() : void {
			
			var event:ProxyEvent = new ProxyEvent(ProxyEvent.CALL_BEGIN);
			
			dispatchEvent( event );
		}
		
		protected function dispatchCallCompleteEvent() : void {
			
			var event:ProxyEvent = new ProxyEvent(ProxyEvent.CALL_COMPLETE);
			
			dispatchEvent( event );
		}
		
		protected function createCall(completeFunction:Function, errorFunction:Function=null) : CallResponder {
			try
			{
				this.dispatchCallBeginEvent();
				
				var caller:CallResponder = new CallResponder();
				
				caller.addEventListener(FaultEvent.FAULT, onFaultEvent);
				
				caller.addEventListener(
					ResultEvent.RESULT, 
					
					function (event:ResultEvent) : void
					{
						
						if ( !resultServiceOk( caller.lastResult ))  {
							if (errorFunction!=null) {
								errorFunction(caller.lastResult);
							}
							return; //Dispara un evento de error
						}
												
						completeFunction(caller.lastResult);
						
						dispatchCallCompleteEvent();
					}
					
				);
				
				return caller;
								
			}
			catch(err:Error)
			{ 
				dispatchInternalError( err );
			}
			
			return null;
		}
		
		protected function createMultipleCall(completeFunction:Function, ... args) : Dictionary {
			try
			{
				this.dispatchCallBeginEvent();
				
				var callers:Dictionary = new Dictionary();
				var results:Dictionary = new Dictionary();
				
				for (var i:uint = 0; i < args.length; i++)  { 
					callers[ args[i] ] = new CallResponder();
					results[ args[i] ] = null;
				} 
				
				var caller:MultipleCaller = new MultipleCaller();
								
				caller.addEventListener(FaultEvent.FAULT, onFaultEvent);
				
				for (var key:String in callers) {
					caller.addResponder( callers[key] );
				}
				
				caller.addEventListener( 
					ResultEvent.RESULT, 
					
					function (event:ResultEvent) : void
					{
						
						for (var key:String in callers) {
							if ( !resultServiceOk( callers[key].lastResult )) return; //Dispara un evento de error
							
							results[key] = callers[key].lastResult;
						}
						
						completeFunction( results );
						
						dispatchCallCompleteEvent();
						
					}
					
				);
			
				return callers;
			}
			catch (err:Error)
			{
				dispatchInternalError( err );
			}
			
			return null;
		}
		
	}
}