package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.bdpfl.plugin.PPTWidgetScrubber;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class pptWidgetScrubberPlugin extends Sprite implements IPluginFactory
	{
		public function pptWidgetScrubberPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new PPTWidgetScrubber();
		}
	}
}