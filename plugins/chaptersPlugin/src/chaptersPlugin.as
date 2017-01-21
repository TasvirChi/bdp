package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class chaptersPlugin extends Sprite implements IPluginFactory
	{
		public function chaptersPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String=null) : IPlugin
		{
			return new ChaptersPluginCode();
		}
	}
}