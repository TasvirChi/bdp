package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class closedCaptionsPlugin extends Sprite implements IPluginFactory
	{
		public function closedCaptionsPlugin():void
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new closedCaptionsPluginCode();
		}
	}
}