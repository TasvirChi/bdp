package com.borhan.bdpfl.controller
{
	import com.borhan.bdpfl.component.ComponentData;
	import com.borhan.bdpfl.controller.media.PostSequenceEndCommand;
	import com.borhan.bdpfl.controller.media.PreSequenceEndCommand;
	import com.borhan.bdpfl.model.LayoutProxy;
	import com.borhan.bdpfl.model.SequenceProxy;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.bdpfl.view.controls.ComboFlavorMediator;
	import com.borhan.bdpfl.view.controls.FullscreenMediator;
	import com.borhan.bdpfl.view.controls.FuncWrapper;
	import com.borhan.bdpfl.view.controls.PlayMediator;
	import com.borhan.bdpfl.view.controls.ScreensMediator;
	import com.borhan.bdpfl.view.controls.ScrubberMediator;
	import com.borhan.bdpfl.view.controls.TimerMediator;
	import com.borhan.bdpfl.view.controls.VolumeMediator;
	import com.borhan.bdpfl.view.controls.WatermarkMediator;
	import com.borhan.bdpfl.view.media.KMediaPlayer;
	import com.borhan.bdpfl.view.media.KMediaPlayerMediator;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * This class is responsible for registering command and mediators that "come to life" after the initial load of the skin and ui components.
	 */	
	public class AssignBehaviorCommand extends SimpleCommand
	{
		/**
		 * represents a constant prefix that indicates we should registed the notification 
		 */		
		public static const NOTIFICATION_PREFIX:String = "on_";
		
		/**
		 * Goes over the visual components of the layout and registers their mediators.
		 * @param note
		 */		
		override public function execute(note:INotification):void
		{
			var layoutProxy:LayoutProxy = facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			
			for each(var comp:ComponentData in layoutProxy.components)
			{
				//register mediator if needed
				switch(comp.className)
				{
					case "KMediaPlayer":
						facade.registerMediator( new KMediaPlayerMediator( KMediaPlayerMediator.NAME , comp.ui as KMediaPlayer ) );
					break;
					case "KScrubber":
						facade.registerMediator( new ScrubberMediator(comp.ui) );
					break;
					case "KTimer":
						facade.registerMediator( new TimerMediator(comp.ui) );
					break;
					case "KVolumeBar":
						facade.registerMediator( new VolumeMediator( comp.ui ) );
					break;
					case "KFlavorComboBox":
						facade.registerMediator( new ComboFlavorMediator( comp.ui ) );
					break
					case "Screens":
						facade.registerMediator( new ScreensMediator( comp.ui ) );
					break;
					case "Watermark":
						facade.registerMediator( new WatermarkMediator( comp.ui ) );
					break;
				}
				
				//If the component has a "command" attribute, register a special mediator for said component.
				switch(comp.attr["command"])
				{
					case "play":
						facade.registerMediator(new PlayMediator(comp.ui));
					break;
					case "fullScreen":
						facade.registerMediator(new FullscreenMediator(comp.ui));
					break;
				}
				//If the component has a "kClick" attribute, register a function to be executed when the component is clicked
				if(comp.attr["kClick"])
				{
					var fw:FuncWrapper = new FuncWrapper();
					fw.registerToEvent(comp.ui as IEventDispatcher, MouseEvent.CLICK, comp.attr["kClick"]);
				}
				
				for (var att : String in comp.attr)
				{
					if (att.indexOf("kevent_") != -1)
					{
						var eventFW:FuncWrapper = new FuncWrapper();
						eventFW.registerToEvent(comp.ui as IEventDispatcher, att.replace("kevent_", ""), comp.attr[att]);
					}
					//register to notification
					else if (att.indexOf(NOTIFICATION_PREFIX)==0) 
					{
						var notificationFW:FuncWrapper = new FuncWrapper();
						notificationFW.registerToNotification(att.substr(NOTIFICATION_PREFIX.length, att.length-NOTIFICATION_PREFIX.length), comp.attr[att]);
						facade.registerMediator(notificationFW);
					}
				}
			}
			
			facade.registerCommand( NotificationType.PRE_SEQUENCE_COMPLETE , PreSequenceEndCommand );

			facade.registerCommand( NotificationType.POST_SEQUENCE_COMPLETE , PostSequenceEndCommand );
			
			facade.registerCommand( NotificationType.MID_SEQUENCE_COMPLETE , MidSequenceEndCommand );
				
			//dispacth layout ready
			sendNotification(NotificationType.LAYOUT_READY);
		}	
	}
}