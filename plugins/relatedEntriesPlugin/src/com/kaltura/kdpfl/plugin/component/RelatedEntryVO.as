package com.borhan.bdpfl.plugin.component
{
	import com.borhan.vo.BorhanBaseEntry;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	/**
	 * This class represents related entry object 
	 * @author michalr
	 * 
	 */	
	public class RelatedEntryVO extends ObjectProxy
	{
		/**
		 * Borhan entry object 
		 */		
		public var entry:BorhanBaseEntry;
		/**
		 * is this the next selected entry 
		 */		
		public var isUpNext:Boolean;
		
		public var isOver:Boolean;
		
		public function RelatedEntryVO(entry:BorhanBaseEntry, isUpNext:Boolean = false)
		{
			this.entry = entry;
			this.isUpNext = isUpNext;
		}
	}
}