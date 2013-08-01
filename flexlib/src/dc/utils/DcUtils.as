

package dc.utils
{
	import com.adobe.serializers.json.JSONDecoder;
	import com.adobe.serializers.json.JSONEncoder;
	
	import dc.components.PopupTitleWindow;
	import dc.components.RequestButton;
	import dc.components.RequestView;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.validators.Validator;
	
	import org.as3commons.reflect.JSONTypeProvider;
	
	import spark.components.Application;
	import spark.components.DataGrid;
	
	public class DcUtils
	{
		public function DcUtils() {
			throw new Error("This class con not be Instanstiate.");
		}
		
		public static function newSibling(sourceObj:Object):* {
			if(sourceObj) {
				
				var objSibling:*;
				try {
					var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
					objSibling = new classOfSourceObj();
				}
				
				catch(e:Object) {}
				
				return objSibling;
			}
			return null;
		}
		
		public static function clone(source:Object):Object {
			
			var clone:Object;
			if(source) {
				clone = newSibling(source);
				
				if(clone) {
					copyData(source, clone);
				}
			}
			
			return clone;
		}
		
		public static function copyData(source:Object, destination:Object):void {
			
			//copies data from commonly named properties and getter/setter pairs
			if((source) && (destination)) {
				
				try {
					var sourceInfo:XML = describeType(source);
					var prop:XML;
					
					for each(prop in sourceInfo.variable) {
						
						if(destination.hasOwnProperty(prop.@name)) {
							destination[prop.@name] = source[prop.@name];
						}
						
					}
					
					for each(prop in sourceInfo.accessor) {
						if(prop.@access == "readwrite") {
							if(destination.hasOwnProperty(prop.@name)) {
								destination[prop.@name] = source[prop.@name];
							}
							
						}
					}
				}
				catch (err:Object) {
					;
				}
			}
		}
		
		/**
		 * 
		 * @param datepart (fullyear|month|date|hours|minutes|seconds|milliseconds)
		 * @param number value
		 * @param date init Date
		 * @return 
		 * 
		 */		
		public static function dateAdd(datepart:String = "", number:Number = 0, date:Date = null):Date {
			if (date == null) {
				/* Default to current date. */
				date = new Date();
			}
			
			var returnDate:Date = new Date(date.valueOf());
			
			switch (datepart.toLowerCase()) {
				case "fullyear":
				case "month":
				case "date":
				case "hours":
				case "minutes":
				case "seconds":
				case "milliseconds":
					returnDate[datepart] += number;
					break;
				default:
					/* Unknown date part, do nothing. */
					break;
			}
			return returnDate;
		}
		
		static public function getEndOfMonth(date:Date) : uint
		{
			var month:Date = new Date(date.fullYear, date.month+1, 0);
			
			//trace( month.date )
			
			return month.date;
		}
		
		static public function getRequestViewContainer(target:IVisualElement) : RequestView {
			
			if (target==null) return null;
			
			var parent:* = target.parent;
			
			while (parent) {
				
				if (parent is Application) return null;
				
				if (parent is RequestView) return parent;
				
				parent = parent.parent;
			}
		
			return null;
		}
		
		static public function getPopUpContainer(target:IVisualElement) : PopupTitleWindow {
			
			if (target==null) return null;
			
			var parent:* = target.parent;
			
			while (parent) {
				
				if (parent is Application) return null;
				
				if (parent is PopupTitleWindow) return parent;
				
				parent = parent.parent;
			}
			
			return null;
		}
		
		static public function validateArray(validators:Array) : Boolean {
			var res:Array = Validator.validateAll( validators );
			
			if (res == null) return true;
			
			if (res.length == 0) return true;
			
			return false;
		}
		
		public static function getGridContainer(target:IVisualElement):DataGrid
		{
			if (target==null) return null;
			
			var parent:* = target.parent;
			
			while (parent) {
				
				if (parent is Application) return null;
				
				if (parent is DataGrid) return parent;
				
				parent = parent.parent;
			}
			
			return null;
		}
		
		public static function hide(component:UIComponent) : Boolean {
		
			try {
				component.enabled = false;
				component.visible = false;
				component.includeInLayout = false;
				return true;
			} catch (err:Error) {
			}
	
			return false;
		}
		
		public static function show(component:UIComponent, enabled:Boolean=true) : Boolean {
			
			try {
				component.enabled = true;
				component.visible = true;
				component.includeInLayout = true;
				return true;
			} catch (err:Error) {
			}
			
			return false;
		}
		
		public static function hasFlag(flags:uint,flag:uint) :Boolean {
			return ((flags & flag) == flag);
		}
		
		public static function encodeJson(obj:*) : String {
			var e:JSONEncoder = new JSONEncoder();
			
			return e.encode(obj);
		}
		
		public static function decodeJson(json:String, clazz:Class=null,makeObjectsBindable:Boolean=true) : * {
			var d:JSONDecoder = new JSONDecoder();
			
			return d.decode(json,clazz,makeObjectsBindable);
		}
				
	}
}