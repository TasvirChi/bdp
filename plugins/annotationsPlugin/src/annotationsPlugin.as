package
{
	import com.borhan.bdpfl.plugin.IPlugin;
	import com.borhan.bdpfl.plugin.IPluginFactory;
	import com.borhan.bdpfl.view.Annotation;
	import com.borhan.bdpfl.view.AnnotationsBox;
	import com.yahoo.astra.fl.controls.containerClasses.ButtonBar;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import fl.controls.Label;
	import fl.controls.List;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	public class annotationsPlugin extends Sprite implements IPluginFactory
	{
		public function annotationsPlugin()
		{
			Security.allowDomain("*");

		}
		
		public function create (name : String = null) : IPlugin
		{
			return new annotationsPluginCode();	 
		}

	}
}