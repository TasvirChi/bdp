 package com.borhan.bdpfl.controller
{
	import com.borhan.bdpfl.model.LayoutProxy;
	import com.borhan.bdpfl.model.type.NotificationType;
	import com.borhan.bdpfl.plugin.PluginManager;
	import com.borhan.bdpfl.view.MainViewMediator;
	import com.borhan.bdpfl.view.RootMediator;
	import com.borhan.bdpfl.view.containers.KCanvas;
	import com.borhan.bdpfl.view.controls.ToolTipManager;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;

	/**
	 * This class is responsible for parsing layout xml and creating BDP layout. 
	 */	
	public class ParseLayoutCommand extends AsyncCommand
	{
		private var _layoutProxy:LayoutProxy;
		
		/**
		 * Start building Layout according to the layout xml 
		 * @param note
		 */		
		override public function execute(note:INotification):void
		{
			_layoutProxy = facade.retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
			//var flashvars : Object = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
			//TODO hook this with the BDP swf path 				
			//if(!flashvars.debugMode) //if this is debug mode load the modules localy
				//_pluginsPath = "http://" + _flashvars.host + "/";
				
			//build all components and layout them and wrap the top component with the MainViewMediator
			buildComponents(_layoutProxy.vo.layoutXML.children()[0]);
			getAllScreens();
			
			var mainView : MainViewMediator = facade.retrieveMediator( MainViewMediator.NAME ) as MainViewMediator;	
			var rm:RootMediator = facade.retrieveMediator(RootMediator.NAME) as RootMediator;
			//add the main view to the stage
			rm.root.addChild(mainView.view);
			//add the foreground layer and set it to the layoutProxy.vo
			var canvas:KCanvas = new KCanvas();
			//TODO: see if we can take this out of the skin file. 
			canvas.setSkin("clickThrough",true);
			canvas.width = 1;
			canvas.height = 1;
			_layoutProxy.vo.foreground = canvas;
			ToolTipManager.getInstance().foregroundLayer = _layoutProxy.vo.foreground;
			rm.root.addChild(canvas);
			rm.onResize(new Event(Event.RESIZE));
			
			var pm : PluginManager = PluginManager.getInstance();
			pm.updateAllLoaded(onAllPluginsLoaded);
/*			//if there are no plugins or all loaded
			if(pm.loadingQ <= 0)
				commandComplete();
			else //other listen to all plugins loaded and then continue
			{
				pm.addEventListener( PluginManager.ALL_PLUGINS_LOADED , onAllPluginsLoaded );
			}
*/		}
		
		/**
		 * Get the screens XML, create an instance of uiConf to each one, and push 
		 * it to the _screens array
		 */
		public function getAllScreens():void
		{
			var screens:Object = new Object();
			var screensXML:XML = _layoutProxy.vo.layoutXML.child('screens')[0];
			if(!screensXML)
				return;
			var allScreens:XMLList = screensXML.children();
			var uiComponent:Object;
			for each( var screen:XML in allScreens )
			{
				//build the screen assuming its 1st child is a container
				uiComponent = _layoutProxy.buildLayout(screen.children()[0]);
				//push it to _screens to retrieve it later on
				screens[screen.attribute('id')] = uiComponent;
			}
			_layoutProxy.vo.screens = screens;
		}
		
		/**
		 * Call the main build function and set the Layout Model components 
		 * @param layout xml
		 * @return main view uicomponent
		 * 
		 */		
		public function buildComponents(xml:XML):void
		{
			facade.registerMediator( new MainViewMediator( _layoutProxy.buildLayout(xml) ) );
			var mainView : MainViewMediator = facade.retrieveMediator( MainViewMediator.NAME ) as MainViewMediator;
		}
		
		private function onAllPluginsLoaded( event : Event ) : void
		{
			event.target.removeEventListener( PluginManager.ALL_PLUGINS_LOADED , onAllPluginsLoaded );
			sendNotification(NotificationType.PLUGINS_READY, _layoutProxy.pluginsMap);
			commandComplete();
		}
	}
}