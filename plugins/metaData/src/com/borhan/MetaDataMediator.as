package com.borhan
{
	import com.borhan.commands.metadata.MetadataList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bdpfl.util.XMLUtils;
	import com.borhan.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.vo.BorhanMetadata;
	import com.borhan.vo.BorhanMetadataFilter;
	import com.borhan.vo.BorhanMetadataListResponse;BorhanMetadata;

	
	public class MetaDataMediator extends SequenceMultiMediator
	{
		
		
		
		public function MetaDataMediator(viewComponent : Object=null)
		{
			super(viewComponent);
			facade["bindObject"]["metaData"] = viewComponent;
		}
		
		
		
		public function start () : void
		{
			var kc : BorhanClient = facade.retrieveProxy("servicesProxy")["borhanClient"] as BorhanClient;
			var entryId : String = facade.retrieveProxy("mediaProxy")["vo"]["entry"]["id"];
			var metadataFilter : BorhanMetadataFilter = new BorhanMetadataFilter();
			metadataFilter.metadataObjectTypeEqual = BorhanMetadataObjectType.ENTRY;
			metadataFilter.objectIdEqual = entryId;
			var metaDataList : MetadataList = new MetadataList(metadataFilter);
			metaDataList.addEventListener(BorhanEvent.COMPLETE, onMetadataReceived);
			metaDataList.addEventListener( BorhanEvent.FAILED, onMetadataFailed );
			kc.post( metaDataList );
		}
		
		private function onMetadataReceived (e : BorhanEvent) : void
		{
			viewComponent["metaData"] = new Object();
			var listResponse : BorhanMetadataListResponse = e.data as BorhanMetadataListResponse;
			if ( listResponse.objects[0])
			{
				var metadataXml : XMLList = XML(listResponse.objects[0]["xml"]).children();
				var metaDataObj : Object = new Object();
				for each (var node : XML in metadataXml)
				{
					metaDataObj[node.name().toString()] = node.valueOf().toString();
				}
				viewComponent["metaData"] = metaDataObj;
			}
			sendNotification("sequenceItemPlayEnd");
		}
		
		private function onMetadataFailed ( e: BorhanEvent) : void
		{
			trace("metadata failed");
			sendNotification("sequenceItemPlayEnd");
		}
	}
}