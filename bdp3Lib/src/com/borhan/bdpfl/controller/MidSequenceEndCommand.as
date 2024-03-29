package com.borhan.bdpfl.controller
{
	import com.borhan.bdpfl.model.MediaProxy;
	import com.borhan.bdpfl.model.SequenceProxy;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.osmf.proxy.KSwitchingProxyElement;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class MidSequenceEndCommand extends SimpleCommand
	{
		public function MidSequenceEndCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			if ((mediaProxy.vo.media as KSwitchingProxyElement).proxiedElement != (mediaProxy.vo.media as KSwitchingProxyElement).mainMediaElement)
			{
				(mediaProxy.vo.media as KSwitchingProxyElement).switchElements();
			}
			sequenceProxy.vo.midrollArr = new Array();
			sequenceProxy.vo.midCurrentIndex = -1;
			sequenceProxy.vo.isInSequence = false;
			sendNotification( NotificationType.DO_PLAY );
		}
	}
}