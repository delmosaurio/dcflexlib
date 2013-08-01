package dc.collection
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class PaginatedCollection extends ArrayCollection
	{
		
		private var _collection:ArrayCollection;
		
		private var _pageSize:int = 0;
		
		private var _currentPage:int = 1;
		
		private var _pageCount:int = 0;
		
		private var _count:int = 0;
		
		private var _pageitems:int = 0;
		
		public function PaginatedCollection(pageSize:int, collection:IList=null)
		{
			super();
			
			_pageSize = pageSize;
			this.collection = collection;
		}
		
		public function set collection(value:IList) : void {
			
			if (!value) return;
			
			if (value is Array) {
				_collection = new ArrayCollection(value as Array);
			} else if(value is ArrayCollection) {
				_collection = value as ArrayCollection;
			} else {
				return;
			}
			
			refreshCollection();
		}
		
		public function get collection() : IList {
			return _collection;
		}
		
		[Bindable]
		public function get currentPage():int {
			return _currentPage;
		}
		
		public function set currentPage(value:int):void {
			_currentPage = value;
			refreshCollection();
		}
		
		[Bindable]
		public function get pageCount():int {
			return _pageCount;
		}
		
		private function set pageCount(value:int):void {
			_pageCount = value;
		}
		
		[Bindable]
		public function get totalItems() : int {
			return _count;
		}
		
		private function set totalItems(value:int) : void {
			_count = value;
		}
		
		[Bindable]
		public function get pageItems() : int {
			return _pageitems;
		}
		
		private function set pageItems(value:int) : void {
			_pageitems = value;
		}
		
		[Bindable]
		public function get pageSize():int {
			return _pageSize;
		}
		
		public function set pageSize(value:int):void {
			_pageSize = value;
		}
		
		private function refreshCollection():void {
			if ( _pageSize <= 0) return;
			
			pageCount = Math.ceil(_collection.length/_pageSize);
			this.totalItems = _collection.length;
			
			var buffer:int = (currentPage-1)*_pageSize;
			
			paginate( (buffer+1), buffer+_pageSize);
			
			_pageitems = this.length;
			
			dispatchEvent( new Event("collectionRefreshed"));
		}
		
		private function paginate(from:int=1,to:int=1) : void {
			if (!_collection) return;
			
			from = from <= 0 ? 0 : (from-1);
			to = (to >= _collection.length) ? (_collection.length-1) : to-1;
			
			this.removeAll();
			
			for (var i:int=from; i<=to; i++) {
				this.addItem( 	_collection.getItemAt(i));
			}
			
		}
		
		public function next() : int {
			if (currentPage == pageCount) { return currentPage; }
			
			currentPage++;
			
			refreshCollection();
			
			return _currentPage;
		}
		
		public function prev() : int {
			if (_currentPage == 1) { return currentPage; }
			
			currentPage--;
			
			refreshCollection();
			
			return currentPage;
		}
		
		public function first() : int {
			if (currentPage == 1) { return currentPage; }
			currentPage == 1
			
			refreshCollection();
			
			return currentPage;
		}
		
		public function last() : int {
			if (currentPage == pageCount) { return currentPage; }
			currentPage == pageCount;
			
			refreshCollection();
			
			return currentPage;
		}
		
		override public function refresh() : Boolean {
			if (!_collection) return false;
			_collection.filterFunction = this.filterFunction;
			
			var res:Boolean = _collection.refresh();
			
			refreshCollection();
			
			return res;
		}
	}
}