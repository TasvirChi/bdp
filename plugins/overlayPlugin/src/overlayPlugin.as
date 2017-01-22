package {
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * Overlay plugin is used to show VAST ads over the BDP video area 
	 */	
	public class overlayPlugin extends Sprite implements IPluginFactory
	{
		/**
		 * Constructor 
		 */		
		public function overlayPlugin()
		{
			Security.allowDomain("*");
		}
		
	
		/**
		 * create actual plugin 
		 */		
		public function create (pluginName : String = null) : IPlugin
		{
			return new overlayPluginCode();
		}
	}
}
