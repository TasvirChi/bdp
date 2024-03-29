package com.borhan.bdpfl.plugin.component
{
	import com.borhan.bdpfl.model.MediaProxy;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.bdpfl.view.media.KMediaPlayerMediator;
	import com.borhan.types.BorhanAdType;
	import com.borhan.vo.BorhanAdCuePoint;
	import com.borhan.vo.BorhanCuePoint;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class NielsenVideoCensusMediator extends Mediator
	{
		
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "nielsenMediator";
		public static const DISPATCH_BEACON:String	= "dispatchBeacon";
		public static const AD_START:String			= "adStart";
		
		public var eventDispatcher:EventDispatcher	= new EventDispatcher();
		private var _plugin:nielsenVideoCensusPluginCode;
		private var _customEvents:Array;
		private var _segments:Array;
		public var eventData:Object;
		
		
		public function NielsenVideoCensusMediator(cEvents:Array)
		{
			_customEvents			= cEvents;
			super(NAME);
		}
		
		/**
		 * Hook to the relevant BDP notifications
		 */
		override public function listNotificationInterests():Array
		{
			
			var notificationsArray:Array =  [
				"adStart",
				"playerPlayed",
				"mediaReady",
				"adEnd",
				NotificationType.MID_SEQUENCE_COMPLETE,
				NotificationType.CUE_POINTS_RECEIVED,
				NotificationType.CHANGE_MEDIA
			];
			notificationsArray		= notificationsArray.concat(_customEvents);
			return notificationsArray;
		}
		
		/**
		 * @inheritDocs
		 */		
		private var _isNewLoad:Boolean	= false;
		private var _played:Boolean		= false;
		private var _lastId:String		= "";
		private var _lastSeek:Number;
		private var _adTimeStamp:Number	= 0;
		private var _midSequenceComplete:Boolean	= false;
		private var _segmentsCounter:Number	= 1;
		private var _prevStartTime:Number	= 0;
		private var _newStartTime:Number		= 0;
		//total number of segments, determined by number of ad cue points
		private var _numOfSegments:int;
		override public function handleNotification(note:INotification):void
		{
			var data:Object = note.getBody();
			switch(note.getName()) 
			{
				case "playerPlayed":
					eventData	= new Object();
					eventData["segmentId"]	= _segmentsCounter;
					eventData["totalSegments"]	= _numOfSegments;
					var length:Number		= Number(_newStartTime - _prevStartTime);
					if(length == 0 && _isNewLoad){
						length= Math.round(Number(facade.retrieveProxy("mediaProxy")["vo"]["entry"]["duration"]));
					}
					eventData["length"]		= length;
					if(_midSequenceComplete && _played){
						//check adTimeStamp against segments. 
						sendBeacon();
						_midSequenceComplete		= false;
					}
					
					if (_isNewLoad && !_played && !(this.facade.retrieveProxy("sequenceProxy")["vo"]["isInSequence"]))
					{				
						_segmentsCounter	= 1;
						_played = true;
						sendBeacon();
					}
					
					break;
				case "mediaReady":
					if((facade.retrieveProxy("mediaProxy"))["vo"].entry.id){
						if (_lastId != (facade.retrieveProxy("mediaProxy"))["vo"].entry.id)
						{
							_played = false;
							_isNewLoad = true;
						}
						else
						{
							_isNewLoad = false;
							_lastSeek = 0;
						}  
					}
					break;
				case NotificationType.MID_SEQUENCE_COMPLETE:
					_midSequenceComplete				= true;
					_segmentsCounter++;
					_prevStartTime						= _newStartTime;
					_newStartTime						= Math.round((facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).getCurrentTime());
					break;
				
				case NotificationType.CUE_POINTS_RECEIVED:
					_numOfSegments = 1;
					var cuePointsMap:Object = note.getBody();
					var entryMSDuration:int = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.msDuration;
					for (var inTime:String in cuePointsMap) {
						//not preroll and not postroll
						if (parseInt(inTime)!=0 && parseInt(inTime)!=entryMSDuration) {
							var cpArray:Array = cuePointsMap[inTime];
							//if at least one cuePoint represents a midroll
							for (var i:int = 0; i<cpArray.length; i++) {
								if ((cpArray[i] is BorhanAdCuePoint) &&
									(cpArray[i] as BorhanAdCuePoint).adType == BorhanAdType.VIDEO)
								{
									_numOfSegments++;
									break;
								}
							}
							
						}
					}
					break;
				
				case NotificationType.CHANGE_MEDIA:
					_numOfSegments = 0;
				
				default:
					for (var s:String in _customEvents)
						if(note.getName() == s)
							sendBeacon();
					break;
				
			}
		}
		
		
		
		
		private function getEndTime(data:Object, id:Number):Number{
			if(data[id] != null){
				return Number((data[id][0] as BorhanCuePoint).startTime);
			}else{
				return (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy).vo.entry.msDuration;
			}
		}
		
		private function sortArrayByTimeline(a:*,b:*):int{
			if (Number(a) < Number(b)) 
				return -1; 
			else if (Number(a) > Number(b)) 
				return 1; 
			else 
				return 0; 
		}
		
		
		private function sendBeacon():void{
			eventDispatcher.dispatchEvent(new Event(DISPATCH_BEACON));
		}
		
	}
}