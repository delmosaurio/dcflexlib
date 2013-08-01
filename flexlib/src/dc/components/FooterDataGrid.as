////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2011 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package dc.components
{
    import dc.components.gridClasses.FooterGridColumn;
    
    import flash.events.Event;
    
    import mx.collections.ArrayList;
    import mx.collections.IList;
    import mx.events.CollectionEvent;
    
    import spark.components.DataGrid;
    import spark.components.gridClasses.GridColumn;
    
	public class FooterDataGrid extends DataGrid
	{
		public function FooterDataGrid()
		{
			super();
		}
        //----------------------------------
        //  footer
        //----------------------------------
        
        [Bindable]
        [SkinPart(required="false")]
        
        /**
         *  A reference to the Grid control that displays the footer.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */
        public var footer:spark.components.Grid;    
        
        /**
         *  @private
         */
        override public function set dataProvider(value:IList):void
        {
            if (super.dataProvider)
                super.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                    collectionChangeHandler);
            super.dataProvider = value;

            if (value)
            {
                value.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                    collectionChangeHandler);
                // compute footer object for new dataprovider
                refreshFooterDataProvider();
            }
        }
        
        /**
         *  @private
         */
        override protected function partAdded(partName:String, instance:Object):void
        {
            super.partAdded(partName, instance);
            
            if (instance == footer)
            {
                // Basic Initialization
                
                footer.dataGrid = this;
                footer.dataProvider = footerDataProvider;
                footer.columns = columns;
                var n:int = columns.length;
                for (var i:int = 0; i < n; i++)
                {
                    columns.getItemAt(i).addEventListener("widthChanged", invalidateFooter);
                }
                if (grid)
                {
                    grid.columns = null;
                    grid.columns = footer.columns;  // reset grid columns
                    // footer will be redrawn since it is in the "chrome"
                }
                
                // IFactory valued skin parts => Grid visual element properties
                footer.columnSeparator = columnSeparator;
                footer.rowSeparator = rowSeparator;

            } 
            // these are needed because you can't control the order
            // that the parts are added.  Sometimes the footer is
            // added before the columnSeparator so the columnSeparator
            // will be null until it is added.
            else if (instance == columnSeparator)
            {
                if (footer)
                    footer.columnSeparator = columnSeparator;
            }
            else if (instance == rowSeparator)
            {
                if (footer)
                    footer.rowSeparator = rowSeparator;
            }
        }

        private function invalidateFooter(event:Event):void
        {
            footer.invalidateSize();
            footer.invalidateDisplayList();
        }
        
        protected function collectionChangeHandler(event:CollectionEvent):void
        {
            // on any collection event, refresh the summary object
            refreshFooterDataProvider();
        }
        
        private var footerDataProvider:ArrayList = new ArrayList([{}]);
        
        protected function refreshFooterDataProvider():void
        {
            // create a one item ArrayList with the fields from the
            // columns that contain the footer values.
            var cols:IList = columns;
            var summaryObject:Object = {};
            var n:int = cols.length;
            for (var i:int = 0; i < n; i++)
            {
                var col:GridColumn = cols.getItemAt(i) as GridColumn;
                if (col is FooterGridColumn)
                {
                    var fcol:FooterGridColumn = col as FooterGridColumn;
                    summaryObject[col.dataField] = fcol.summaryFunction(dataProvider, col.dataField);
                }
            }
            footerDataProvider.setItemAt(summaryObject, 0);
        }
        
    }
}