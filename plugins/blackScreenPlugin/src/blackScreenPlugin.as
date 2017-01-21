package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class blackScreenPlugin extends Sprite implements IPluginFactory
	{
		public function blackScreenPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create ( pluginName : String = "" ) : IPlugin
		{
			return new BlackScreenPluginCode();
		}
	}
}