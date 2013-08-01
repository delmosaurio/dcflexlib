package dc.rpc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.CallResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class MultipleCaller extends EventDispatcher
	{
		
		private var countLenght:int=0;
		
		private var callers:ArrayCollection;
		
		private var callersStatus:Dictionary;
		
		public function MultipleCaller(target:IEventDispatcher=null)
		{
			super(target);
			
			callers = new ArrayCollection();
			callersStatus = new Dictionary();
		}
		
		public function addResponder(call:CallResponder, key:String=null) : void
		{
			if (!key)
				key = "caller" + (countLenght+1);
			
			callers.addItem( call );
			callersStatus[call] = "listen";
			
			call.addEventListener(FaultEvent.FAULT, callFaultHandler) 
			call.addEventListener( ResultEvent.RESULT, callResultHandler)
			
			countLenght++;
		}
		
		protected function callResultHandler(event:ResultEvent):void
		{
			callersStatus[event.currentTarget] = "result";
			
			checkStatus();
		}
		
		protected function callFaultHandler(event:FaultEvent):void
		{
			
			dispatchEvent( event );
			
			callersStatus[event.currentTarget] = "fault";
			
			checkStatus();
		}
		
		private function checkStatus():void
		{
			for each(var key:String in callersStatus)
			{
				if (key=="fault") return;
				
				if (key=="listen") return;
			}
			
			dispatchEvent( new ResultEvent(ResultEvent.RESULT));
			
		}
		
	}
}