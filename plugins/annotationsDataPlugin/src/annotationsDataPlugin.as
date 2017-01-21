package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class annotationsDataPlugin extends Sprite implements IPluginFactory
	{
		public function annotationsDataPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (name : String = null) : IPlugin
		{
			return new AnnotationsDataPluginCode();
		}
	}
}