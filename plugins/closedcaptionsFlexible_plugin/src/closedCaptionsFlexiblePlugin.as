package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.bdpfl.plugin.component.ClosedCaptions;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class closedCaptionsFlexiblePlugin extends Sprite implements IPluginFactory
	{
		public function closedCaptionsFlexiblePlugin():void
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new closedCaptionsFlexiblePluginCode();
		}
	}
}