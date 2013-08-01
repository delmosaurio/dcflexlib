package dc.collection
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public class PagedArrayCollection extends ArrayCollection implements IPagedArrayCollection
	{
		private var _currentPage:Number = 1;
		private var _numberOfPages:Number = 1;
		private var _pageSize:Number = 30;
		
		private var _notSortedIndex:Dictionary = new Dictionary();
		
		public function PagedArrayCollection( source:Array=null )
		{
			super( source );
			super.filterFunction = filterData;
			addEventListener( CollectionEvent.COLLECTION_CHANGE, onChange );
		}  
		
		/**
		 * Adds an item to the collection at the specified index.
		 *
		 * @param item Item to be added
		 * @param index Index of the item to be added
		 *
		 * Note: Needs to be overridden in order to trigger refresh.
		 *        AddItem eventually calls this function so its not needed to override addItem 
		 **/
		override public function addItemAt( item:Object, index:int ) : void
		{
			super.addItemAt( item, index );
			refresh();
		}
		
		/**
		 * Removes the item from the collection at the specified index
		 *
		 * @param index Index of the item to be removed
		 * @return The item removed
		 *
		 * Note: Needs to be overridden in order to trigger refresh
		 **/
		override public function removeItemAt( index:int ) : Object
		{
			var removedItem:Object = super.removeItemAt( index );
			refresh();
			return removedItem;
		}
		
		protected function onChange( event:CollectionEvent ) : void
		{
			if( _numberOfPages != numberOfPages )
			{
				_numberOfPages = numberOfPages;
				onPagingChange( PagedCollectionEventKind.NUMBEROFPAGES_CHANGE );
			}
		}
		
		protected function onPagingChange( kind:String ) : void
		{
			dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE, false, false, kind ) );
		}  
		
		[ChangeEvent("collectionChange")]
		[Bindable]
		public function get currentPage() : Number
		{
			return _currentPage;
		}
		
		public function set currentPage( value:Number ) : void
		{
			_currentPage = value;
			refresh();
			onPagingChange( PagedCollectionEventKind.CURRENTPAGE_CHANGE );
		}
		
		[ChangeEvent("collectionChange")]
		[Bindable("collectionChange")]
		public function get numberOfPages() : Number
		{
			var result:Number = source.length / pageSize;
			result = Math.ceil( result );
			return result;
		}
		
		[ChangeEvent("collectionChange")]
		[Bindable]
		public function get pageSize() : Number
		{
			return _pageSize;
		}
		
		public function set pageSize( value:Number ) : void
		{
			_pageSize = value;
			refresh();
			onPagingChange( PagedCollectionEventKind.PAGESIZE_CHANGE );
		}
		
		[ChangeEvent("collectionChange")]
		[Bindable("collectionChange")]
		public function get lengthTotal() : Number
		{
			return source.length;
		}
		
		public function next() : int {
			if (currentPage == numberOfPages) { return currentPage; }
			
			currentPage++;
					
			return currentPage;
		}
		
		public function prev() : int {
			if (_currentPage == 1) { return currentPage; }
			
			currentPage--;
			
			return currentPage;
		}
		
		public function first() : int {
			if (currentPage == 1) { return currentPage; }
			currentPage = 1			
			return currentPage;
		}
		
		public function last() : int {
			if (currentPage == numberOfPages) { return currentPage; }
			currentPage = numberOfPages;
			return currentPage;
		}
		
		private function filterData( item:Object ) : Boolean {
			var dataWindowCeiling:Number = pageSize * currentPage;
			var dataWindowFloor:Number = dataWindowCeiling - pageSize;
			
			var itemIndex:Number = getItemIndex( item );
			if (this.sort != null) {
				itemIndex = _notSortedIndex[item];
			}
			
			var result:Boolean = dataWindowFloor <= itemIndex && itemIndex < dataWindowCeiling;
			
			if (_hasCustomFilterFunction) {
				return _filterFunction(item) && result;
			}
			
			return result;
		}
		
		private var _filterFunction:Function;
		
		private var _hasCustomFilterFunction:Boolean = false;
		
		override public function set filterFunction(value:Function) : void {
			_filterFunction = value;
			_hasCustomFilterFunction=value != null;
		}
		
		override public function get filterFunction() : Function {
			return _filterFunction;	
		}
		
		private function filterDataAlwaysTrue( item:Object ) : Boolean {
			return true;
		}
				
		override public function refresh() : Boolean {
			var res:Boolean = false;
			var f:Function;
			
			// filter items and sort
			if ((this.filterFunction != null && _hasCustomFilterFunction) || this.sort != null) {
				
				if (!_hasCustomFilterFunction) {
					f = this.filterFunction;
					this.filterFunction = filterDataAlwaysTrue;
					_hasCustomFilterFunction=false;
					this.filterFunction = f;
				}
				
				res = super.refresh();
				// set not ordered index
				var c:int = 0;
				for each(var item:Object in this) {
					_notSortedIndex[item] = c++;	
				}
			}
			
			f = this.filterFunction;
			
			// now paginate			
			this.filterFunction = filterData;
			_hasCustomFilterFunction=false;
			
			res = super.refresh();
			
			this.filterFunction = f;	
						
			return res;
		}
		
	}
}