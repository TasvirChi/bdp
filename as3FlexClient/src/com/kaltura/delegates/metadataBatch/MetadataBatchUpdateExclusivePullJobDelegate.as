package com.kaltura.delegates.metadataBatch
{
	import flash.utils.getDefinitionByName;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	public class MetadataBatchUpdateExclusivePullJobDelegate extends WebDelegateBase
	{
		public function MetadataBatchUpdateExclusivePullJobDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

	}
}
