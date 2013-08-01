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

/**
 *  Add a function to GridColumn that will be used to compute what is displayed
 *  in the footer
 */
package dc.components.gridClasses
{
    import spark.components.gridClasses.GridColumn;
    
    public class FooterGridColumn extends GridColumn
    {
        public function FooterGridColumn(columnName:String=null)
        {
            super(columnName);
        }
        
        /**
         *  summaryFunction(dataProvider, columnName):Object;  // usually number or string
         */
        public var summaryFunction:Function;
    }
}