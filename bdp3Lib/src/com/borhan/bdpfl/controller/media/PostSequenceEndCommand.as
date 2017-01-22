package com.borhan.bdpfl.controller.media
{
	import com.borhan.bdpfl.model.ConfigProxy;
	import com.borhan.bdpfl.model.MediaProxy;
	import com.borhan.bdpfl.model.SequenceProxy;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.bdpfl.model.type.StreamerType;
	import com.borhan.vo.BorhanLiveStreamEntry;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * PostSequenceEndCommand is called when the post-sequence of the player is complete.
	 * In case of a live-streaming entry, the player immediately attempts to restore connection to the stream.
	 * In case of a normal entry the notification "PLAYER_PLAY_END" is fired. 
	 * All variables which have to do with the post-sequence are nullified and the sequence is registered as COMPLETE.
	 */
	public class PostSequenceEndCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			sequenceProxy.vo.isInSequence = false;
			sequenceProxy.vo.postCurrentIndex = -1;
			sequenceProxy.vo.postSequenceComplete = true;
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			//sequenceProxy.vo.replacedMedia = true;
			//mediaProxy.loadWithoutMediaReady();
			if(mediaProxy.vo.isLive)
			{
				mediaProxy.vo.singleAutoPlay = true;
				sendNotification(NotificationType.CHANGE_MEDIA, {entryId:mediaProxy.vo.entry.id});
			}
			else
			{
				sendNotification( NotificationType.PLAYER_PLAY_END );
				var flashvars:Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
				//if we want to display ads on replay, reset prerolls and postrolls
				if (flashvars.adsOnReplay && flashvars.adsOnReplay=="true")
				{
					sequenceProxy.resetPrePostSequence()
				}
			}
		}
	}
}