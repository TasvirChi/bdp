package com.kaltura.delegates.captionAsset
{
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class CaptionAssetGetDownloadUrlDelegate extends WebDelegateBase
	{
		public function CaptionAssetGetDownloadUrlDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			return result.result.toString();
		}

	}
}
