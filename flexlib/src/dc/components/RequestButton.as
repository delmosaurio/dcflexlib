package dc.components
{
	import dc.events.DataEvent;
	import dc.events.PopUpWindowEvent;
	import dc.events.ViewEvent;
	import dc.utils.DcUtils;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.as3commons.lang.StringUtils;
	
	import spark.components.Button;
	import spark.components.DataGrid;
	
	public class RequestButton extends Button
	{
		
		public var link:String = "";
		
		public var linkParams:* = "";
		
		public var eventType:String = "";
		
		public var data:*;
		
		private var _rView:RequestView;
		
		private var _rForm:PopupTitleWindow;
		
		private var _rGrid:DataGrid;
		
		private var _busy:Boolean=false;
		
		[Inspectable(enumeration="view,popup,none", defaultValue="view")]
		[Bindable] public var containerType:String = "view";
		
		public function RequestButton() {
			super();
			
			this.buttonMode = true;
			this.addEventListener(Event.ADDED, addedHandler);
		}
		
		protected function addedHandler(event:Event): void 	{
			_rView = null;
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			//Antirrebote
			if (_busy) {
				event.preventDefault();
				return; 
			}
			
			//var today:Date = new Date();
			//trace(StringUtils.substitute("{0}-{1}: Pulse!", today.seconds, today.milliseconds));
			
			_busy = true;
			
			var t:Timer = new Timer(500);
			t.addEventListener(
				TimerEvent.TIMER,
				function (te:TimerEvent) : void {
					t.stop();
					_busy = false;
					//var today:Date = new Date();
					//trace(StringUtils.substitute("{0}-{1}: Pulse!", today.seconds, today.milliseconds));
				}
			)
			t.start();
			
			super.clickHandler(event);
			
			if (link != "") {
				
				var app:RequestApplication = FlexGlobals.topLevelApplication as RequestApplication;
				app.goTo(link, linkParams);
			}
			
			if (eventType == "") { return; }
			
			//Dispatch GridEvent
			if (gridContainer) {
				var de:DataEvent = new DataEvent(eventType);
				de.data = this.data;
				gridContainer.dispatchEvent( de );
			}
			
			if (containerType=="none") return;
			
			var target:IEventDispatcher=null;
			
			var ve:* = new ViewEvent(eventType);
			
			if (containerType=="popup") {
				target = popupContainer;
				ve = new PopUpWindowEvent( eventType );
			} else {
				target = viewContainer;
			}
			
			if (!target) { return; }
			
			ve.data = this.data;
			
			target.dispatchEvent( ve );
						
		}
		
		public function get viewContainer() : RequestView {
			if (_rView) return _rView;
			
			_rView = DcUtils.getRequestViewContainer( this );
			
			return _rView;
		}
		
		public function get popupContainer() : PopupTitleWindow {
			if (_rForm) return _rForm;
			
			_rForm = DcUtils.getPopUpContainer( this );
			
			return _rForm;
		}
		
		public function get gridContainer() : DataGrid {
			if (_rGrid) return _rGrid;
			
			_rGrid = DcUtils.getGridContainer( this );
			
			return _rGrid;
		}
				
	}
}