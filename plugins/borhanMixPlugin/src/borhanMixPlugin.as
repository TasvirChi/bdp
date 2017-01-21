package {
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.osmf.borhanMix.BorhanMixElement;
	import com.borhan.osmf.borhanMix.BorhanMixPluginInfo;
	import com.borhan.osmf.borhanMix.BorhanMixSprite;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.osmf.elements.*;
	import org.osmf.media.PluginInfoResource;
	import org.osmf.media.pluginClasses.PluginManager;
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * 
	 * @author Atar
	 */
	public class borhanMixPlugin extends Sprite implements IPlugin, IPluginFactory {
		
		/**
		 * the url from where to load required plugins
		 * @default  {CDN_SERVER_URL}/flash/mixplugins/v3.0
		 */
		public static var mixPluginsBaseUrl:String = "{CDN_SERVER_URL}/flash/mixplugins/v4.0";
		
		/**
		 * @default false 
		 */
		public var disableUrlHashing:Boolean = false;



		/**
		 * Constructor
		 */
		public function borhanMixPlugin() {
			Security.allowDomain("*");
			var k:BorhanMixElement;
		}


		/**
		 * create plugin
		 * @param pluginName
		 * @return an instance of the "Real" plugin
		 */
		public function create(pluginName:String = null):IPlugin {
			return this;
		}


		/**
		 * initialize plugin manager etc
		 * @param facade	Application Facade
		 */
		public function initializePlugin(facade:IFacade):void {
			BorhanMixSprite.facade = facade;
			var mediaProxy:Object = facade.retrieveProxy("mediaProxy");
			var pluginManager:PluginManager = mediaProxy.vo.osmfPluginManager;
			var pluginResource:PluginInfoResource = new PluginInfoResource(new BorhanMixPluginInfo(disableUrlHashing));
			pluginManager.loadPlugin(pluginResource);
		}


		/**
		 * no implementation to interface method
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
		}
	}
}
