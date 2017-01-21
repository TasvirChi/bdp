package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.bdpfl.plugin.PPTWidgetScreenPluginCode;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class pptWidgetScreenPlugin extends Sprite implements IPluginFactory
	{
		public function pptWidgetScreenPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new PPTWidgetScreenPluginCode();
		}
	}
}