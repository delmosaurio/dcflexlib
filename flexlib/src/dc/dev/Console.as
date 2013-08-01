package dc.dev
{
	import dc.events.LoggerEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class Console implements IEventDispatcher
	{
		private var dispatcher:EventDispatcher;
				
		private static var _instance:Console;
		
		private var _buffer:ArrayCollection  = new ArrayCollection();
		
		public var befferEnabled:Boolean = true;
		
		public function Console() {
			
			if (_instance!=null) {
				throw new Error("Singleton - Can't Instanstiate");
			}
			
			_instance = this;
			dispatcher = new EventDispatcher();
		}
		
		public static function getInstance():Console {
			if (_instance == null)
				_instance = new Console();
			
			return _instance;
		}
		
		[Bindable("collectionChange")]
		public function get buffer() : ArrayCollection {
			return _buffer;
		}
		
		
		private function makeEntry(...params) : String {
			var entry:String = "";
			for each(var obj:* in params) {
				if (!obj || obj.toString() == "") continue;
				
				if (entry != "") entry += " ";
				
				entry += obj.toString();
			}
			return entry;
		}
		
		private function addEntry(obj:*) : void {
			if (befferEnabled) {
				_buffer.addItem( obj );	
			}
			
			// dispatch the event
			var de:LoggerEvent = new LoggerEvent(obj.type, obj.entry);
			dispatchEvent( de );
		}
		
		public function log(...params) : void {
			var entry:String = makeEntry(params);
			addEntry({ type:LoggerEvent.LOG, entry:entry, date: new Date() });
		}
		
		public function error(...params) : void {
			var entry:String = makeEntry(params);
			addEntry({ type:LoggerEvent.ERROR, entry:entry, date: new Date() });
		}
		
		public function info(...params) : void {
			var entry:String = makeEntry(params);
			addEntry({ type:LoggerEvent.INFO, entry:entry, date: new Date() });
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
		
	}
}