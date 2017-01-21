package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class AudioDescriptionPlugin extends Sprite implements IPluginFactory
	{
		public function AudioDescriptionPlugin():void
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			var plugin:IPlugin = new AudioDescriptionPluginCode();
			return plugin;
		}
	}
}