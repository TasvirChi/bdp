package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * playlistAPIPlugin handles sequencial playing of memdia entries
	 */	
	public class playlistAPIPlugin extends Sprite implements IPluginFactory
	{
				
		public function playlistAPIPlugin()
		{
			Security.allowDomain("*");			
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new playlistAPIPluginCode();
		}
	}
}