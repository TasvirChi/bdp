package com.borhan.osmf.borhanMix
{
	import com.borhan.osmf.borhan.BorhanBaseEntryResource;
	import com.borhan.vo.BorhanMixEntry;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	public class BorhanMixLoader extends LoaderBase
	{
		public function BorhanMixLoader()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function executeLoad(loadTrait:LoadTrait):void
		{	
			updateLoadTrait(loadTrait, LoadState.LOADING);
			updateLoadTrait(loadTrait, LoadState.READY);		
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function executeUnload(loadTrait:LoadTrait):void
		{
			updateLoadTrait(loadTrait, LoadState.UNLOADING); 			
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED); 
							
		}
		
		/**
		 * @inheritDoc
		 */
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			//if (resource is BorhanEntryResource && (resource as BorhanEntryResource).entry is BorhanEntry)
			//	return true;
			if (resource is BorhanBaseEntryResource && (resource as BorhanBaseEntryResource).entry is BorhanMixEntry)
				return true;
				
			return false;
		}
		
	}
}