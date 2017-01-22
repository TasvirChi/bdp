package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.bdpfl.plugin.WVMediaElement;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class widevinePlugin extends Sprite implements IPluginFactory
	{
		public function widevinePlugin()
		{
			var wv: WVMediaElement;
		}
		
		public function create(pluginName : String = null) : IPlugin
		{
			return new widevinePluginCode();
		}
		
		public function initializePlugin(facade:IFacade):void {
			
		}
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void {}
		
	}
}