package {
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	import com.borhan.bdpfl.plugin.CarouselPluginCode;

	public class carouselPlugin extends Sprite implements IPluginFactory
	{
		public function carouselPlugin()
		{
			Security.allowDomain("*");	
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new CarouselPluginCode();
		}
	}
}
