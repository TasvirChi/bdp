package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.metaDataPluginCode;
	
	import flash.display.Sprite;
	
	public class metaDataPlugin extends Sprite implements IPluginFactory
	{
		public function metaDataPlugin()
		{
			
		}
		public function create (pluginName:String=null) : IPlugin
		{
			return new metaDataPluginCode();
		}
	}
}