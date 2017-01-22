package com.borhan.osmf.borhanMix {

	import com.borhan.BorhanClient;
	import com.borhan.application.BorhanApplication;
	import com.borhan.assets.AssetsFactory;
	import com.borhan.assets.abstracts.AbstractAsset;
	import com.borhan.base.context.PartnerInfo;
	import com.borhan.base.types.MediaTypes;
	import com.borhan.base.types.TimelineTypes;
	import com.borhan.base.vo.BorhanPluginInfo;
	import com.borhan.commands.mixing.MixingGetReadyMediaEntries;
	import com.borhan.components.players.eplayer.Eplayer;
	import com.borhan.events.BorhanEvent;
	import com.borhan.managers.downloadManagers.types.StreamingModes;
	import com.borhan.model.BorhanModelLocator;
	import com.borhan.osmf.borhan.BorhanBaseEntryResource;
	import com.borhan.plugin.types.transitions.TransitionTypes;
	import com.borhan.roughcut.Roughcut;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.utils.url.URLProccessing;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	import com.quasimondo.geom.ColorMatrix;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.core.MovieClipAsset;
	import mx.core.SpriteAsset;
	
	import org.osmf.traits.MediaTraitType;
	import org.puremvc.as3.interfaces.IFacade;


	public class BorhanMixSprite extends Sprite {
		// must have these classes compiled into code
		private var m:MovieClipAsset;
		private var f:SpriteAsset;
		private var c:ColorMatrix;

		/**
		 * mix plugin facade 
		 */		
		static public var facade:IFacade;
		
		private var kc:BorhanClient;

		/**
		 * mix player 
		 */		
		public var eplayer:Eplayer;

		/**
		 * entries ready
		 */		
		public var isReady:Boolean = false;

		private var _width:Number;
		private var _height:Number;

		private var kapp:BorhanApplication;
		private var mediaElement:BorhanMixElement;
		private var mixEntry:BorhanMixEntry;
		private var roughcut:Roughcut = null;

		static private var mixPluginsLoaded:Boolean = false;
		static private var pluginListLoader:URLLoader;
		
		/**
		 * @default false 
		 */		
		public var disableUrlHashing:Boolean = false;


		/**
		 * load different plugins
		 * @param data plugins data
		 */		
		public function loadPlugins(data:Object):void {
			var model:BorhanModelLocator = BorhanModelLocator.getInstance();
			var pluginsProvider:Array = data as Array;
			//var pluginsProvider:Array = data.result;
			/* pluginsProvider:   [transitionsArray, overlaysArray, textOverlaysArray, effectsArray] */
			var pinfo:BorhanPluginInfo;
			var baseUrl:String;
			var thumbUrl:String;
			var debugFromIDE:Boolean = kapp.applicationConfig.debugFromIDE;
			var pluginsUrl:String = URLProccessing.prepareURL(model.applicationConfig.pluginsFolder + "/", !debugFromIDE, false);
			for (var i:int = 0; i < pluginsProvider.length; ++i) {
				for (var j:int = 0; j < pluginsProvider[i].length; ++j) {
					pinfo = pluginsProvider[i].getItemAt(j) as BorhanPluginInfo;
					baseUrl = pluginsUrl + model.applicationConfig.transitionsFolder + "/" + pinfo.pluginId + "/";
					thumbUrl = pinfo.thumbnailUrl == '' ? baseUrl + "thumbnail.swf" : pinfo.thumbnailUrl;
					pinfo.thumbnailUrl = thumbUrl;
				}
			}
			kapp.transitions = pluginsProvider[0];
			kapp.overlays = pluginsProvider[1];
			kapp.textOverlays = pluginsProvider[2];
			kapp.effects = pluginsProvider[3];
			thumbUrl = model.applicationConfig.pluginsFolder + "/" + model.applicationConfig.transitionsFolder + "/thumbnail.swf";
			BorhanApplication.nullAsset.transitionThumbnail = URLProccessing.prepareURL(thumbUrl, true, false);
			model.logStatus = "plugins loaded and instantiated.";
			var nonePlugin:BorhanPluginInfo = model.transitions.getItemAt(0) as BorhanPluginInfo;
			AbstractAsset.noneTransitionThumbnail = nonePlugin.thumbnailUrl;
		}

		/**
		 * set plugin data before load
		 * @param data plugin data
		 */
		public function loadPlugingList(data:Object):void {
			var buildPlugin:Function = function(p:XML, media_type:uint):BorhanPluginInfo {
					var kpinf:BorhanPluginInfo = new BorhanPluginInfo(media_type, p.@plugin_id, p.@thumbnail, p.parent().@type, p.@label, p.@creator, p.description);
					return kpinf;
				}

			var pluginsXml:XML = data as XML;
			var transitionsArray:ArrayCollection = new ArrayCollection();
			var overlaysArray:ArrayCollection = new ArrayCollection();
			var textOverlaysArray:ArrayCollection = new ArrayCollection();
			var effectsArray:ArrayCollection = new ArrayCollection();
			var pinf:BorhanPluginInfo;
			var noneTransition:BorhanPluginInfo;
			var pluginXml:XML;
			for each (pluginXml in pluginsXml..transitions..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.TRANSITION);
				if (pinf.category == "ignore")
					noneTransition = pinf;
				else
					transitionsArray.addItem(pinf);
			}
			transitionsArray.addItemAt(noneTransition, 0);
			for each (pluginXml in pluginsXml..overlays..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.OVERLAY);
				overlaysArray.addItem(pinf);
			}
			for each (pluginXml in pluginsXml..textOverlays..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.TEXT_OVERLAY);
				textOverlaysArray.addItem(pinf);
			}
			for each (pluginXml in pluginsXml..effects..plugin) {
				pinf = buildPlugin(pluginXml, MediaTypes.EFFECT);
				effectsArray.addItem(pinf);
			}

			loadPlugins([transitionsArray, overlaysArray, textOverlaysArray, effectsArray]);

		}

		/**
		 * get a list ready entries 
		 */
		public function getReadyEntries():void {
			var getMixReadyEntries:MixingGetReadyMediaEntries = new MixingGetReadyMediaEntries(mixEntry.id, mixEntry.version);

			getMixReadyEntries.addEventListener(BorhanEvent.COMPLETE, complete);
			getMixReadyEntries.addEventListener(BorhanEvent.FAILED, failed);
			kc.post(getMixReadyEntries);
		}


		private function failed(event:BorhanEvent):void {
			trace("getMixReadyEntries", event.toString());
		}


		private function complete(event:BorhanEvent):void {
			roughcut = new Roughcut(mixEntry);
			kapp.addRoughcut(roughcut);

			var readyEntriesResult:* = event.data;
			if (readyEntriesResult is Array) {
				var readyEntries:Array = readyEntriesResult as Array;
				var asset:AbstractAsset;
				var thumbUrl:String;
				var mediaUrl:String;
				for each (var entry:BorhanMediaEntry in readyEntries) {
					entry.mediaType = MediaTypes.translateServerType(entry.mediaType);
					asset = roughcut.associatedAssets.getValue(entry.id);
					if (asset)
						continue;
					kapp.addEntry(entry);
					if (entry.status != BorhanEntryStatus.BLOCKED && entry.status != BorhanEntryStatus.DELETED && entry.status != BorhanEntryStatus.ERROR_CONVERTING) {
						//thumbUrl = URLProccessing.hashURLforMultipalDomains (entry.thumbnailUrl, entry.id);
						mediaUrl = entry.mediaUrl;
						asset = AssetsFactory.create(entry.mediaType, 'null', entry.id, entry.name, thumbUrl, mediaUrl, entry.duration, entry.duration, 0, 0, TransitionTypes.NONE, 0, false, false, null, entry);
						asset.borhanEntry = entry;
						asset.mediaURL = entry.dataUrl;
						asset.entryContributor = entry.creditUserName;
						asset.entrySourceCode = parseInt(entry.sourceType);
						asset.entrySourceLink = entry.creditUrl;
						roughcut.associatedAssets.put(entry.id, asset);
						roughcut.originalAssets.addItem(asset);
						roughcut.mediaClips.addItem(asset);
					}
				}
			}
			isReady = true;
			if ((mediaElement.getTrait(MediaTraitType.PLAY) as BorhanMixPlayTrait).playState == "playing") {
				loadAssets();
			}
		/* var sdl:XML = new XML (mixEntry.dataContent);
		   roughcut.parseSDL (sdl, false);

		   var Timelines2Load:int = TimelineTypes.VIDEO | TimelineTypes.TRANSITIONS | TimelineTypes.AUDIO | TimelineTypes.OVERLAYS | TimelineTypes.EFFECTS;
		   roughcut.streamingMode = StreamingModes.PROGRESSIVE_STREAM_DUAL;
		   roughcut.loadAssetsMediaSources (Timelines2Load, roughcut.streamingMode);

		   eplayer.roughcut = roughcut;
		 (mediaElement.getTrait(MediaTraitType.TIME) as BorhanMixTimeTrait).setSuperDuration(roughcut.roughcutDuration); */
		}

		/**
		 * load media sources of assets 
		 */
		public function loadAssets():void {
			var sdl:XML = new XML(mixEntry.dataContent);
			roughcut.parseSDL(sdl, false);

			var Timelines2Load:int = TimelineTypes.VIDEO | TimelineTypes.TRANSITIONS | TimelineTypes.AUDIO | TimelineTypes.OVERLAYS | TimelineTypes.EFFECTS;
			roughcut.streamingMode = StreamingModes.PROGRESSIVE_STREAM_DUAL;
			roughcut.loadAssetsMediaSources(Timelines2Load, roughcut.streamingMode);

			eplayer.roughcut = roughcut;
			(mediaElement.getTrait(MediaTraitType.TIME) as BorhanMixTimeTrait).setSuperDuration(roughcut.roughcutDuration);
			(mediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as BorhanMixViewTrait).isSpriteLoaded = true;
		}

		/**
		 * setup the sprite ui 
		 * @param _width	sprite width
		 * @param _height	sprite height
		 */
		public function setupSprite(_width:Number, _height:Number):void {
			this._width = _width;
			this._height = _height;
			graphics.beginFill(0xff);
			graphics.drawRect(0, 0, _width, _height);

			eplayer = new Eplayer();
			addChild(eplayer);
			eplayer.updateDisplayList(_width, _height);
		}


		/**
		 * Constructor. 
		 * @param _mediaElement
		 * @param _width
		 * @param _height
		 * @param isHashDisabled
		 */		
		public function BorhanMixSprite(_mediaElement:BorhanMixElement, _width:Number, _height:Number, isHashDisabled:Boolean) {
			disableUrlHashing = isHashDisabled;
			URLProccessing.disable_hashURLforMultipalDomains = disableUrlHashing;
			kapp = BorhanApplication.getInstance();
			mediaElement = _mediaElement;
			mixEntry = BorhanBaseEntryResource(mediaElement.resource).entry as BorhanMixEntry;
			setupSprite(_width, _height);

			var servicesProxy:Object = facade.retrieveProxy("servicesProxy");
			kc = servicesProxy.borhanClient;

			var configProxy:Object = facade.retrieveProxy("configProxy");
			var flashvars:Object = configProxy.getData().flashvars;

			var app:BorhanApplication = BorhanApplication.getInstance();
			var partnerInfo:PartnerInfo = new PartnerInfo();
			partnerInfo.partner_id = kc.partnerId;
			partnerInfo.subp_id = "0";
			app.initBorhanApplication("", null);
			kapp.partnerInfo = partnerInfo;

			URLProccessing.serverURL = flashvars.httpProtocol + flashvars.host;
			URLProccessing.cdnURL = flashvars.httpProtocol + flashvars.cdnHost;

			if (!mixPluginsLoaded) {
				var baseUrl:String = borhanMixPlugin.mixPluginsBaseUrl;
				kapp.applicationConfig.pluginsFolder = URLProccessing.completeUrl(baseUrl, URLProccessing.BINDING_CDN_SERVER_URL);

				var url:String = kapp.applicationConfig.pluginsFolder + "/" + (flashvars.mixPluginsListFile ? flashvars.mixPluginsListFile : "plugins.xml");
				var urlRequest:URLRequest = new URLRequest(url);
				pluginListLoader = new URLLoader();
				pluginListLoader.addEventListener(Event.COMPLETE, loadedPluginsList);
				pluginListLoader.load(urlRequest);
			}
			else {
				getReadyEntries();
			}
		}


		/**
		 * video width 
		 */		
		public function get videoWidth():Number {
			return this.width;
		}


		/**
		 * video height 
		 */
		public function get videoHeight():Number {
			return this.height;
		}


		private function loadedPluginsList(e:Event):void {
			pluginListLoader.removeEventListener(Event.COMPLETE, loadedPluginsList);
			mixPluginsLoaded = true;
			loadPlugingList(new XML(e.target.data));
			getReadyEntries();
		}
	}
}
