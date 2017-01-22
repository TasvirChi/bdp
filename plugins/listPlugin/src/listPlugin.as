package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class listPlugin extends Sprite implements IPluginFactory
	{
		public function listPlugin()
		{
			Security.allowDomain("*");			
		}
		public function create(pluginName : String = null) : IPlugin	
		{
			return new listPluginCode();
		}
	}
}