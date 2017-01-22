package com.borhan.bdpfl.controller.media
{
	import com.borhan.BorhanClient;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryGet;
	import com.borhan.commands.baseEntry.BaseEntryGetContextData;
	import com.borhan.commands.flavorAsset.FlavorAssetGetWebPlayableByEntryId;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bdpfl.model.ConfigProxy;
	import com.borhan.bdpfl.model.MediaProxy;
	import com.borhan.bdpfl.model.ServicesProxy;
	import com.borhan.bdpfl.model.strings.MessageStrings;
	import com.borhan.bdpfl.model.type.SourceType;
	import com.borhan.types.BorhanEntryModerationStatus;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanEntryContextDataParams;
	import com.borhan.vo.BorhanLiveStreamEntry;BorhanLiveStreamEntry;
	import com.borhan.vo.BorhanLiveStreamAdminEntry; BorhanLiveStreamAdminEntry;
	import com.borhan.vo.BorhanLiveStreamBitrate; BorhanLiveStreamBitrate;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	import com.borhan.vo.BorhanFlavorAsset;
	import com.borhan.vo.BorhanWidevineFlavorAsset; BorhanWidevineFlavorAsset;
	import com.borhan.bdpfl.model.type.StreamerType;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.bdpfl.view.media.KMediaPlayer;
	import com.borhan.bdpfl.view.media.KMediaPlayerMediator;
	import com.borhan.bdpfl.model.type.EnableType;
	import flash.events.Event;
	import com.borhan.vo.BorhanMetadataListResponse;
	import com.borhan.vo.BorhanMetadataFilter;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.commands.metadata.MetadataList;
	import com.borhan.net.BorhanCall;
	import com.borhan.commands.metadata.MetadataGet;
	import com.borhan.bdpfl.model.PlayerStatusProxy;
	import com.borhan.bdpfl.model.SequenceProxy;
	import com.borhan.types.BorhanMetadataOrderBy;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanCuePointFilter;
	import com.borhan.commands.cuePoint.CuePointList;
	import com.borhan.vo.BorhanCuePointListResponse;
	import com.borhan.vo.BorhanCuePoint;
	import com.borhan.vo.BorhanAdCuePoint;BorhanAdCuePoint;
	import com.borhan.vo.BorhanCodeCuePoint;BorhanCodeCuePoint;
	import com.borhan.vo.BorhanCaptionAsset;
	import com.borhan.types.BorhanAdProtocolType;
	import com.borhan.types.BorhanAdType;
	import com.borhan.vo.BorhanAnnotation; BorhanAnnotation;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import com.borhan.vo.BaseFlexVo;
	import com.borhan.vo.BorhanMetadata;
	import org.osmf.net.StreamType;
	import com.borhan.bdpfl.model.vo.StorageProfileVO;
	import com.borhan.bdpfl.view.controls.KTrace;
	import com.borhan.commands.baseEntry.BaseEntryList;
	import com.borhan.vo.BorhanBaseEntryFilter;
	import com.borhan.vo.BorhanEntryContextDataResult;
	import com.borhan.commands.baseEntry.BaseEntryListByReferenceId;
	import com.borhan.commands.metadataProfile.MetadataProfileGet;
	import com.borhan.vo.BorhanAccessControlBlockAction;
	import com.borhan.vo.BorhanString;
	import com.borhan.commands.flavorAsset.FlavorAssetList;
	import com.borhan.vo.BorhanFlavorAssetListResponse;
	import com.borhan.vo.BorhanAssetFilter;
	import com.borhan.vo.BorhanFlavorAssetFilter;
	import com.borhan.types.BorhanFlavorAssetStatus;
	import com.borhan.bdpfl.util.SharedObjectUtil;
	import com.borhan.bdpfl.plugin.Plugin;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.AsyncErrorEvent;
	import com.borhan.bdpfl.plugin.PluginManager;
	import mx.utils.URLUtil;
	import com.borhan.bdpfl.util.URLUtils;
	import com.borhan.types.BorhanPlaybackProtocol;
	import mx.controls.Text;
	import com.borhan.bdpfl.util.KTextParser;
	import com.borhan.vo.BorhanLiveChannel;BorhanLiveChannel;

 


	/**
	 * This is the class for the command used to retrieve the entry object and its related data from the Borhan CMS. 
	 * @author Hila
	 * 
	 */	
	public class GetMediaCommand extends AsyncCommand
	{
		
		private var _mediaProxy : MediaProxy;
		private var _sequenceProxy : SequenceProxy;
		private var _flashvars : Object;
		
		
		/**
		 * when true, command will not be completed until akamai plugin load process is done 
		 */		
		private var _waitForAkamaiLoad:Boolean;
		
		/**
		 * The command's execution involves using the Borhan Client to construct a multi-tiered call to the
		 * Borhan CMS (a MultiRequest) and populating it with single-tier calls to get the Entry object, the Flavors array,
		 * the Entry Context Data and the Custom Metadata.
		 * @param notification - the notifcation which triggered the command.
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			_mediaProxy = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy);
			_sequenceProxy = (facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy);
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			_flashvars = configProxy.vo.flashvars;
			_mediaProxy.vo.isMediaDisabled = false;
			// for urls dont fetch entry from borhan;
			if (_flashvars.sourceType == SourceType.URL || _flashvars.sourceType == SourceType.F4M)
			{
				if (!_mediaProxy.vo.entry.id || _mediaProxy.vo.entry.id == "" || _mediaProxy.vo.entry.id== "-1" )
				{
					_mediaProxy.vo.isMediaDisabled = true;
				}
				
				
				commandComplete();
			}
			else if( _mediaProxy.vo.entryLoadedBeforeChangeMedia) 
			{
				_mediaProxy.vo.entryLoadedBeforeChangeMedia = false;
				_mediaProxy.vo.selectedFlavorId = _flashvars.flavorId;
				
				//If this is the first time that the player is running WITHOUT A BDP3WRAPPER, bypass this call, as the entry was retrieved in the LoadConfigCommand stage.
				result({data:[_mediaProxy.vo.entry,_mediaProxy.vo.borhanMediaFlavorArray,_mediaProxy.vo.entryExtraData, (_flashvars.requiredMetadataFields ? _mediaProxy.vo.entryMetadata : null)]});
			}
			else //else call to the get entry service again
			{
				//To do : make multirequest just fetching a new entryId .
				
				var kc : BorhanClient = ( facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).borhanClient;
				var entryId : String = _mediaProxy.vo.entry.id;	// assuming InitMediaChangeProcessCommand put it there
				var refid : String = notification.getBody().referenceId;
				
				if( (entryId && entryId != "-1") || refid )
				{
					var ind:int =  1;
					var mr : MultiRequest = new MultiRequest();
					
					// get entry by refid / redirectEntryId / entryId
					var baseEntryFilter:BorhanBaseEntryFilter = new BorhanBaseEntryFilter();	
					if (refid) {
						baseEntryFilter.referenceIdEqual = refid;
					} else if ( !_flashvars.disableEntryRedirect || _flashvars.disableEntryRedirect == "false" ) {
						baseEntryFilter.redirectFromEntryId = entryId;
					} else {
						baseEntryFilter.idEqual = entryId;
					}
					

					var getEntry : BaseEntryList = new BaseEntryList(baseEntryFilter);
					mr.addAction( getEntry );

					ind ++;
					
					var keedp : BorhanEntryContextDataParams = new BorhanEntryContextDataParams();
					keedp.referrer = _flashvars.referrer;	
					keedp.streamerType = _flashvars.streamerType;
					if (_flashvars.flavorTags)
					{
						keedp.flavorTags = 	_flashvars.flavorTags;
					}
					
					if (_flashvars.flavorId)
					{
						keedp.flavorAssetId = _flashvars.flavorId;
					}
					
					var getExtraData : BaseEntryGetContextData = new BaseEntryGetContextData( _mediaProxy.vo.entry.id , keedp );
					mr.addRequestParam(ind + ":entryId","{1:result:objects:0:id}");
					mr.addAction(getExtraData); 
					ind ++;
					
					if (_flashvars.requiredMetadataFields)
					{
						var metadataAction : BorhanCall;
						
						var metadataFilter : BorhanMetadataFilter = new BorhanMetadataFilter();
						
						metadataFilter.metadataObjectTypeEqual = BorhanMetadataObjectType.ENTRY;
						
						metadataFilter.orderBy = BorhanMetadataOrderBy.CREATED_AT_ASC;
						
						metadataFilter.objectIdEqual = _mediaProxy.vo.entry.id;
						
						if (_flashvars.metadataProfileId)
						{
							metadataFilter.metadataProfileIdEqual = _flashvars.metadataProfileId;
						}
						
						var metadataPager : BorhanFilterPager = new BorhanFilterPager();
						
						metadataPager.pageSize = 1;
						
						metadataAction = new MetadataList(metadataFilter,metadataPager);
						
						mr.addRequestParam(ind + ":filter:objectIdEqual","{1:result:objects:0:id}");
						
						mr.addAction(metadataAction);
						ind ++;
					}
					
					if ( _flashvars.getCuePointsData == "true" && !_mediaProxy.vo.isFlavorSwitching && !_sequenceProxy.vo.isInSequence)
					{
						var cuePointFilter : BorhanCuePointFilter = new BorhanCuePointFilter();
						
						cuePointFilter.entryIdEqual = _mediaProxy.vo.entry.id;
						
						var cuePointList : CuePointList = new CuePointList( cuePointFilter );
						
						mr.addRequestParam(ind + ":filter:entryIdEqual","{1:result:objects:0:id}");
						
						mr.addAction( cuePointList );
						ind ++;
					}
					
					
					mr.addEventListener( BorhanEvent.COMPLETE , result );
					mr.addEventListener( BorhanEvent.FAILED , fault );
					kc.post( mr );
				}
				else
				{
					_mediaProxy.vo.isMediaDisabled = true;
					commandComplete();
				}
			}
			
		}
		/**
		 * The response to the server result. This function reassigns the values returned from the server into the
		 * mediaProxy.vo (value object) so that it is subsequently visible to any Observer-type class (proxy, mediator, command).
		 * @param data - the server response
		 * 
		 */		
		public function result(data:Object):void
		{
			var i : int = 0;
			var arr : Array = data.data as Array;
			
			var entry:BorhanBaseEntry; 
			
			// get entry result:
			// -------------------------
			// check for API error
			if(arr[i] is BorhanError || (arr[i].hasOwnProperty("error")))
			{
				_mediaProxy.vo.isMediaDisabled = true;
				KTrace.getInstance().log("Error in Get Entry");
				sendNotification( NotificationType.ENTRY_FAILED );
				sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_ENTRY_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
			}
			// save the received value
			else
			{
				// arr[i] is BorhanBaseEntryListResponse, take the first entry in the result array
				if (arr[i].objects.length) {
					entry = arr[i].objects[0];
				}
				else {
					KTrace.getInstance().log("Error in Get Entry: No Entry with given filter");
					sendNotification( NotificationType.ENTRY_FAILED );
					sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_ENTRY_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
				}
					
				_mediaProxy.vo.entry = entry;
				
				if(entry is BorhanLiveStreamEntry || _flashvars.streamerType == StreamerType.LIVE)
				{
					_mediaProxy.vo.deliveryType = StreamerType.LIVE;
					_mediaProxy.vo.isLive = true;
					_mediaProxy.vo.canSeek = false;
					_mediaProxy.vo.mediaProtocol = StreamerType.RTMP;
				}
				else
				{
					_mediaProxy.vo.deliveryType = _flashvars.streamerType;
					_mediaProxy.vo.isLive = false;
					_mediaProxy.vo.canSeek = true;
					if (_flashvars.mediaProtocol)
					{
						_mediaProxy.vo.mediaProtocol =  _flashvars.mediaProtocol;
					}
					else
					{
						_mediaProxy.vo.mediaProtocol = _mediaProxy.vo.deliveryType;
					}
				}
			}
			
			++i;
	
			// get ContextData result:
			// -------------------------
			if(arr[i] is BorhanError || (arr[i].hasOwnProperty("error")))
			{
				//TODO: Trace, Report, and notify the user
				KTrace.getInstance().log("Warning : Empty Extra Params");
			}
			else
			{
				_mediaProxy.vo.entryExtraData = arr[i];	
					
				if (_flashvars.streamerType == BorhanPlaybackProtocol.AUTO && _mediaProxy.vo.entryExtraData.streamerType && _mediaProxy.vo.entryExtraData.streamerType != "")
				{
					_mediaProxy.vo.deliveryType = _mediaProxy.vo.entryExtraData.streamerType;
					if (_mediaProxy.vo.entryExtraData.streamerType == BorhanPlaybackProtocol.AKAMAI_HDS || _mediaProxy.vo.entryExtraData.streamerType == BorhanPlaybackProtocol.AKAMAI_HD)
					{
						//load akamaiHD plugin, if it wasn't already loaded
						var akamaiHdPlugin:Object = facade['bindObject']['Plugin_akamaiHD'];
						if (akamaiHdPlugin && !akamaiHdPlugin['content'])
						{
							_waitForAkamaiLoad = true;
							var pluginDomain : String = _flashvars.pluginDomain ? _flashvars.pluginDomain : (facade['appFolder'] + 'plugins/');
							var xml:XML = (akamaiHdPlugin['xml'] as XML);
							var pluginUrl:String = xml.attribute('path');
							if (!pluginUrl)
								pluginUrl = xml.@id + "Plugin.swf";
							else if (!URLUtils.isHttpURL(pluginUrl) && (pluginUrl.charAt(0) == "/") )
							{
								//change to more reliable params
								pluginUrl = _flashvars.httpProtocol + _flashvars.cdnHost + pluginUrl;
							}
							if(!URLUtils.isHttpURL(pluginUrl))
								pluginUrl = pluginDomain + pluginUrl;
							var resultPlugin:Plugin = PluginManager.getInstance().loadPlugin(pluginUrl, "akamaiHD", "wait" , true, _flashvars.fileSystemMode == true);
							resultPlugin.addEventListener( Event.COMPLETE , onAkamaiPluginReady, false, int.MAX_VALUE);
							resultPlugin.addEventListener( IOErrorEvent.IO_ERROR , onAkamaiPluginError );
							resultPlugin.addEventListener( SecurityErrorEvent.SECURITY_ERROR , onAkamaiPluginError );
							resultPlugin.addEventListener( ErrorEvent.ERROR , onAkamaiPluginError );
							resultPlugin.addEventListener( AsyncErrorEvent.ASYNC_ERROR , onAkamaiPluginError );
						}
					}
					
					if (_mediaProxy.vo.entryExtraData.streamerType == BorhanPlaybackProtocol.HDS || _mediaProxy.vo.entryExtraData.streamerType == BorhanPlaybackProtocol.AKAMAI_HDS)
					{
						_mediaProxy.vo.isHds = true;
					}
					else
					{
						_mediaProxy.vo.isHds = false;
					}

					if (_mediaProxy.vo.entryExtraData.mediaProtocol && _mediaProxy.vo.entryExtraData.mediaProtocol != "")
					{
						_flashvars.mediaProtocol =  _mediaProxy.vo.entryExtraData.mediaProtocol;
					}
				}
				
				//remote storage profiles
				_mediaProxy.vo.availableStorageProfiles = new Array();
				//stab: _mediaProxy.vo.entryExtraData.storageProfilesXML = new XML("<StorageProfiles><StrorageProfile storageProfileId='4'><Name>michal</Name><SystemName>blaaaaaaa</SystemName></StrorageProfile><StrorageProfile storageProfileId='8'><Name>michal2222</Name><SystemName>blaaaaaaa33333</SystemName></StrorageProfile></StorageProfiles>");
				if (_mediaProxy.vo.entryExtraData.storageProfilesXML && _mediaProxy.vo.entryExtraData.storageProfilesXML!='') {
					//translate xml profiles to objects
					var profilesXml:XML = new XML(_mediaProxy.vo.entryExtraData.storageProfilesXML);
					for each (var profile:XML in profilesXml.children()) {
						var profileObj:StorageProfileVO = new StorageProfileVO();
						profileObj.storageProfileId = profile.attribute('storageProfileId');
						for each (var profileProp:XML in profile.children()) 
						{
							if ( profileProp.children().length() )
							{
								profileObj[profileProp.localName()] = profileProp.children()[0].toString();
							}
						}
						_mediaProxy.vo.availableStorageProfiles.push(profileObj);
					}
				}
				
				//flavors
				if(!_mediaProxy.vo.entryExtraData.flavorAssets || !_mediaProxy.vo.entryExtraData.flavorAssets.length)
				{
					KTrace.getInstance().log("Warning : Empty Flavors");
					_mediaProxy.vo.borhanMediaFlavorArray = null;
					
					//if this is live entry we will create the flavors using 
					if( entry is BorhanLiveStreamEntry )
					{
						var flavorAssetArray : Array = new Array(); 
						for(var j:int=0; j<entry.bitrates.length; j++)
						{
							var flavorAsset : BorhanFlavorAsset = new BorhanFlavorAsset();
							flavorAsset.bitrate = entry.bitrates[j].bitrate;
							flavorAsset.height = entry.bitrates[j].height;
							flavorAsset.width = entry.bitrates[j].width;
							flavorAsset.entryId = entry.id;
							flavorAsset.isWeb = true;
							flavorAsset.id = j.toString();
							flavorAsset.partnerId = entry.partnerId; 
							flavorAssetArray.push(flavorAsset);
						}
						
						if(j>0)
							_mediaProxy.vo.borhanMediaFlavorArray = flavorAssetArray;
						else
							_mediaProxy.vo.borhanMediaFlavorArray = null;
					}
					else
					{
						_mediaProxy.vo.borhanMediaFlavorArray = null;
					}
				}
				else
				{
					_mediaProxy.vo.borhanMediaFlavorArray = _mediaProxy.vo.entryExtraData.flavorAssets;
										
					//save the highest bitrate available to cookie. This will be used to determine whether we should perform
					//bandwidth check in the future
					if (_mediaProxy.vo.borhanMediaFlavorArray.length)
						SharedObjectUtil.writeToCookie("Borhan", "lastHighestBR", (_mediaProxy.vo.borhanMediaFlavorArray[_mediaProxy.vo.borhanMediaFlavorArray.length - 1] as BorhanFlavorAsset).bitrate, _flashvars.allowCookies);
				} 
				
				
			} 
			
			++i;
			// get CustomData result:
			// -------------------------
			if (_flashvars.requiredMetadataFields)
			{
				if(arr[i] is BorhanError || (arr[i].hasOwnProperty("error")))
				{
					//TODO: Trace, Report, and notify the user
					KTrace.getInstance().log("Warning : Meta data error");
					//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_CUSTOM_METADATA_ERROR_MESSAGE'), title: MessageStrings.getString('SERVICE_ERROR')} );
				}
				else
				{
					var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					
					if (mediaProxy.vo.entryMetadata != arr[i] )
					{
						mediaProxy.vo.entryMetadata = new Object();
						var serviceResponse : BaseFlexVo;
						if (arr[i] is BorhanMetadataListResponse)
						{
							var listResponse:BorhanMetadataListResponse = arr[i] as BorhanMetadataListResponse;
							//take the latest profile
							if (listResponse.objects && listResponse.objects.length)
							{
								serviceResponse = listResponse.objects[listResponse.objects.length - 1];
							}
						}
						else //if we requested a specific profile id
						{
							serviceResponse = arr[i] as BorhanMetadata;
						}
						if ( serviceResponse )
						{
							var metadataXml : XMLList = XML(serviceResponse["xml"]).children();
							var metaDataObj : Object = new Object();
							for each (var node : XML in metadataXml)
							{
								if (!metaDataObj.hasOwnProperty(node.name().toString()))
								{
									metaDataObj[node.name().toString()] = node.valueOf().toString();
								}
								else
								{
									if (metaDataObj[node.name().toString()] is Array)
									{
										(metaDataObj[node.name().toString()] as Array).push(node.valueOf().toString());
									}
									else
									{
										metaDataObj[node.name().toString()] =new Array ( metaDataObj[node.name().toString()]);
										(metaDataObj[node.name().toString()] as Array).push(node.valueOf().toString() );
									}
								}
							}
							
							
							mediaProxy.vo.entryMetadata = metaDataObj;
						}
						sendNotification(NotificationType.METADATA_RECEIVED);
					}
				} 
				++i;
			}
			
			// get cuePoints result:
			// -------------------------
			if ( _flashvars.getCuePointsData == "true" && !_mediaProxy.vo.isFlavorSwitching && !_sequenceProxy.vo.isInSequence)
			{
				if(arr[i] is BorhanError 
					|| (arr[i].hasOwnProperty("error")))
				{
					KTrace.getInstance().log("Warning : No cue points");
				}
				else
				{
					var cuePointListResponse : BorhanCuePointListResponse = arr[i] as BorhanCuePointListResponse;
					
					_mediaProxy.vo.entryCuePoints = new Object();
					
					var cuePointsMap : Object = new Object();
					
					var cuePointsArray : Array = cuePointListResponse.objects;
					
					for each (var cuePoint : BorhanCuePoint in cuePointsArray)
					{
						if (cuePoint is BorhanAdCuePoint && (cuePoint as BorhanAdCuePoint).sourceUrl)
						{
							(cuePoint as BorhanAdCuePoint).sourceUrl = KTextParser.evaluate(facade["bindObject"], (cuePoint as BorhanAdCuePoint).sourceUrl ) as String;
						}
							
						// map cue point according to start time.
						if ( cuePointsMap[cuePoint.startTime] )
						{
							(cuePointsMap[cuePoint.startTime] as Array).push( cuePoint );
						}
						else
						{
							cuePointsMap[cuePoint.startTime] = new Array ();
							(cuePointsMap[cuePoint.startTime] as Array).push( cuePoint );
						}
					}
					_mediaProxy.vo.entryCuePoints = cuePointsMap;
					//Send notification regarding the cue points being received.
					sendNotification( NotificationType.CUE_POINTS_RECEIVED, cuePointsMap );
				}
				++i;
			}
			
			// -----------------
			
			if(entry && (entry.id != "-1") && (entry.id != null) )
			{
				//switch the entry status to print the right error to the screen
				switch( entry.status )
				{
					case BorhanEntryStatus.BLOCKED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')}); sendEntryCannotBePlayed();
						break;	
					case BorhanEntryStatus.DELETED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_DELETED'), title: MessageStrings.getString('ENTRY_DELETED_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case BorhanEntryStatus.ERROR_CONVERTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case BorhanEntryStatus.ERROR_IMPORTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case BorhanEntryStatus.IMPORT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case BorhanEntryStatus.PRECONVERT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); sendEntryCannotBePlayed(); 
						break;
					case BorhanEntryStatus.NO_CONTENT:
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_CONTENT'), title: MessageStrings.getString('NO_CONTENT_TITLE')}); sendEntryCannotBePlayed(); 
						break;
					
					case BorhanEntryStatus.READY: 
						break;
					
					default: 
						//sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNKNOWN_STATUS'), title: MessageStrings.getString('UNKNOWN_STATUS_TITLE')}); break;
						break;
				}
				
				//if this entry is not old and has extra data
				if(_mediaProxy.vo.entryExtraData)
				{
					var entryExtraData:BorhanEntryContextDataResult = _mediaProxy.vo.entryExtraData;
					
					// If the requesting user is not the admin:
					if( !entryExtraData.isAdmin)
					{
						//check if a moderation status alert should be raised
						switch( entry.moderationStatus )
						{
							case BorhanEntryModerationStatus.REJECTED:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')});
								sendEntryCannotBePlayed();
								break;
							case BorhanEntryModerationStatus.PENDING_MODERATION:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_MODERATE'), title: MessageStrings.getString('ENTRY_MODERATE_TITLE')});
								sendEntryCannotBePlayed();
								break;
						}
						
						// check for entry restrictions:
						
						//indicates we already displayed an error message, to prevent duplicate messages
						var retrictionFound:Boolean = false;
						//The player is running in a restricted country.
						if(entryExtraData.isCountryRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_COUNTRY'), title: MessageStrings.getString('UNAUTHORIZED_COUNTRY_TITLE')});
							retrictionFound = true;
							sendNotification(NotificationType.CANCEL_ALERTS);//
							sendEntryCannotBePlayed();
						}
						//The entry is out of scheduling.
						if(!entryExtraData.isScheduledNow){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('OUT_OF_SCHEDULING'), title: MessageStrings.getString('OUT_OF_SCHEDULING_TITLE')});	
							retrictionFound = true;
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						//the player is running on a restricted site.
						if(entryExtraData.isSiteRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_DOMAIN'), title: MessageStrings.getString('UNAUTHORIZED_DOMAIN_TITLE')});
							retrictionFound = true;
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						// The player is running from a restricted IP address.
						if(entryExtraData.isIpAddressRestricted) {
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS'), title: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS_TITLE')});
							retrictionFound = true;
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						// The entry is restricted and the KS is not valid.
						if(entryExtraData.isSessionRestricted && entryExtraData.previewLength <= 0){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_KS'), title: MessageStrings.getString('NO_KS_TITLE')});
							retrictionFound = true;
							sendEntryCannotBePlayed();
						}
						if (entryExtraData.isUserAgentRestricted)
						{
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('USER_AGENT_RESTRICTED'), title: MessageStrings.getString('USER_AGENT_RESTRICTED_TITLE')});
							retrictionFound = true;
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();	
						}
						//only display new access control messages if no other retriction was found
						if (!retrictionFound && entryExtraData.accessControlActions && entryExtraData.accessControlActions.length)
						{
							for (var k:int = 0; k<entryExtraData.accessControlActions.length; k++)
							{
								//if we have at least one block, display all access control messages
								if (entryExtraData.accessControlActions[k] is BorhanAccessControlBlockAction)
								{
									if (entryExtraData.accessControlMessages && entryExtraData.accessControlMessages.length)
									{
										var errString:String = '';
										for (var l:int = 0; l<entryExtraData.accessControlMessages.length; l++)
										{
											errString += (entryExtraData.accessControlMessages[l] as BorhanString).value + '\n';
										}
									}
									//no messages- display generic access control message
									if (!errString)
										errString = MessageStrings.getString('ACCESS_RESTRICTED');
									
									sendNotification(NotificationType.ALERT,{message: errString, title: MessageStrings.getString('ACCESS_RESTRICTED_TITLE')});
									sendEntryCannotBePlayed();
									break;
								}
							}
						}
					}
					
				}

				sendNotification( NotificationType.ENTRY_READY, entry );
				
			}
			else
			{
				_mediaProxy.vo.isMediaDisabled = true;
			}

			if (_mediaProxy.vo.isFlavorSwitching)
			{		
				_mediaProxy.vo.isFlavorSwitching = false;
			}
			commandComplete();
		}
		
		private function sendEntryCannotBePlayed():void {
			sendNotification(NotificationType.ENTRY_NOT_AVAILABLE);
		//	sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: false, enableType : EnableType.CONTROLS});
			_mediaProxy.vo.isMediaDisabled = true;
		}
		
		override protected function commandComplete():void
		{
			if (!_waitForAkamaiLoad)
				super.commandComplete();
		}
		
		/**
		 * The client request has failed
		 * @param data
		 * 
		 */		
		public function fault(data:Object):void
		{
			//TODO: Send more information on the Error
			sendNotification(NotificationType.ENTRY_FAILED );

		 if (data && data.error && (data.error is BorhanError)) 
			KTrace.getInstance().log(data.error.errorMsg);
		}
		
		/**
		 * handler for akamai plugin load error 
		 * @param event
		 * 
		 */		
		private function onAkamaiPluginError( event: Event) : void 
		{
			var plugin : Plugin = ( event.target as Plugin );
			removePluginListeners(plugin);
			///TODO: alert here?
			KTrace.getInstance().log("Failed to load AkamaiHD plugin");
			_mediaProxy.vo.isMediaDisabled = true;
			_waitForAkamaiLoad = false;
			commandComplete();
		}
		
		/**
		 * handler for akamai plugin load 
		 * @param event
		 * 
		 */		
		private function onAkamaiPluginReady( event : Event ) : void
		{
			var plugin : Plugin = ( event.target as Plugin );
			removePluginListeners(plugin);	
			sendNotification(NotificationType.SINGLE_PLUGIN_LOADED, plugin.name);
			_waitForAkamaiLoad = false;
			commandComplete();			
		}
		
		/**
		 * remove event listeners from akamai plugin 
		 * @param plugin
		 * 
		 */		
		private function removePluginListeners(plugin:Plugin):void {
			plugin.removeEventListener( Event.COMPLETE , onAkamaiPluginReady);
			plugin.removeEventListener( IOErrorEvent.IO_ERROR , onAkamaiPluginError );
			plugin.removeEventListener( SecurityErrorEvent.SECURITY_ERROR , onAkamaiPluginError );
			plugin.removeEventListener( ErrorEvent.ERROR , onAkamaiPluginError );
			plugin.removeEventListener( AsyncErrorEvent.ASYNC_ERROR , onAkamaiPluginError );
		}
	}
}