package com.borhan.osmf.borhanMix
{
	import __AS3__.vec.Vector;
	
	import com.borhan.osmf.borhan.BorhanBaseEntryResource;
	import com.borhan.vo.BorhanMixEntry;
	
	import flash.errors.IllegalOperationError;
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.utils.OSMFStrings;

	public class BorhanMixPluginInfo extends PluginInfo
	{
		private var borhanMixLoader:BorhanMixLoader = new BorhanMixLoader();
		private var mediaInfoObjects:Vector.<MediaFactoryItem>;			
		public var disableUrlHashing : Boolean = false;
		public function BorhanMixPluginInfo(isHashDisabled : Boolean)
		{
			super(null,null);
			mediaInfoObjects = new Vector.<MediaFactoryItem>();
			disableUrlHashing = isHashDisabled;
			var mediaInfo:MediaFactoryItem = new MediaFactoryItem("com.borhan.osmf.BorhanMixElement", canHandleResource, createBorhanMixElement);
			mediaInfoObjects.push(mediaInfo);

		}

		/**
		 * @inheritDoc
		 */
		override public function get numMediaFactoryItems():int
		{
			return mediaInfoObjects.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getMediaFactoryItemAt(index:int):MediaFactoryItem
		{
			if (index >= mediaInfoObjects.length)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));				
			}
			
			return mediaInfoObjects[index];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function isFrameworkVersionSupported(version:String):Boolean
		{
			if ((version == null) || (version.length < 1))
			{
				return false;
			}
			
			var verInfo:Array = version.split(".");
			var major:int = 0
			var minor:int = 0
			var subMinor:int = 0;
			
			if (verInfo.length >= 1)
			{
				major = parseInt(verInfo[0]);
			}
			if (verInfo.length >= 2)
			{
				minor = parseInt(verInfo[1]);
			}
			if (verInfo.length >= 3)
			{
				subMinor = parseInt(verInfo[2]);
			}
			
			// Framework version 0.8.0 is the minimum this plugin supports.
			return ((major > 0) || ((major == 0) && (minor >= 8) && (subMinor >= 0)));
		}
		
		private function createBorhanMixElement():MediaElement
		{
			var newElement :BorhanMixElement = new BorhanMixElement(borhanMixLoader);
			newElement.disableUrlHashing = disableUrlHashing;
			return newElement;
		}
		
		/**
		 * checks whether the plugin can handle a resource  
		 * @param resource	resource to check
		 * @return true if the plugin can handle the given resource 
		 */		
		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			//if (resource is BorhanEntryResource && (resource as BorhanEntryResource).entry is BorhanEntry)
			//	return true;
			if (resource is BorhanBaseEntryResource && (resource as BorhanBaseEntryResource).entry is BorhanMixEntry)
				return true;
				
			return false;
		}
		
	}
}