package
{
	import com.borhan.cuePointPluginCode;
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	
	public class cuePointPlugin extends Sprite implements IPluginFactory
	{
		public function cuePointPlugin()
		{
			
		}
		
		public function create (pluginName : String=null) : IPlugin
		{
			return new cuePointPluginCode();
		}
	}
}