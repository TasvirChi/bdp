package com.borhan.bdpfl.component
{
	import com.borhan.bdpfl.view.controls.KButton;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	
	import flash.utils.getDefinitionByName;KButton;
	import com.borhan.bdpfl.view.containers.KVBox;KVBox;
	import com.borhan.bdpfl.view.containers.KHBox;KHBox;
	import com.borhan.bdpfl.view.containers.KCanvas;KCanvas;
	import com.borhan.bdpfl.view.containers.KTile;KTile;
	import com.borhan.bdpfl.view.media.KMediaPlayer;KMediaPlayer;
	import com.borhan.bdpfl.view.controls.KScrubber;KScrubber;
	import com.borhan.bdpfl.view.controls.KVolumeBar;KVolumeBar;
	import com.borhan.bdpfl.view.controls.KTimer;KTimer;
	import com.borhan.bdpfl.view.controls.KLabel;KLabel;
	import com.borhan.bdpfl.view.controls.Screens;Screens;
	import com.borhan.bdpfl.view.controls.Watermark;Watermark;
	import com.borhan.bdpfl.view.media.KThumbnail;KThumbnail;
	import com.borhan.bdpfl.view.controls.KFlavorComboBox;KFlavorComboBox;
	import fl.core.UIComponent;
	import com.borhan.bdpfl.view.controls.KTextField;KTextField;
	import com.borhan.bdpfl.view.controls.KList;KList;
	import com.borhan.bdpfl.view.controls.KTrace;


	////////////////////////////////////////////////////////
	/**
	 * The ComponentFactory class contains the mapping between the xml tag names used in the config.xml file
	 * and the classes constructed for them in the layout building process. 
	 * @author Hila
	 * 
	 */	
	public class ComponentFactory
	{
		/**
		 * Map object between the config.xml tag names and the BDP associated classes. 
		 */		
		public static var _componentMap : Object = 
		{
			Button:"com.borhan.bdpfl.view.controls.KButton",
			VBox:"com.borhan.bdpfl.view.containers.KVBox",
			HBox:"com.borhan.bdpfl.view.containers.KHBox",
			Canvas:"com.borhan.bdpfl.view.containers.KCanvas",
			Tile:"com.borhan.bdpfl.view.containers.KTile",
			Video:"com.borhan.bdpfl.view.media.KMediaPlayer",
			Scrubber:"com.borhan.bdpfl.view.controls.KScrubber",
			VolumeBar:"com.borhan.bdpfl.view.controls.KVolumeBar",
			Label:"com.borhan.bdpfl.view.controls.KLabel",
			Timer:"com.borhan.bdpfl.view.controls.KTimer",
			Screens:"com.borhan.bdpfl.view.controls.Screens",
			Watermark:"com.borhan.bdpfl.view.controls.Watermark",
			Image:"com.borhan.bdpfl.view.media.KThumbnail",
			Spacer:"fl.core.UIComponent",
			FlavorCombo:"com.borhan.bdpfl.view.controls.KFlavorComboBox",
			Text:"com.borhan.bdpfl.view.controls.KTextField",
			ComboBox:"com.borhan.bdpfl.view.controls.KComboBox",
			List:"com.borhan.bdpfl.view.controls.KList"
		}
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ComponentFactory(){}
		
		
		/**
		 * Creates the components supported by the BDP 
		 * @param UIComponent type
		 * @return BDP UIComponent 
		 * 
		 */		
		public function getComponent(type:String):UIComponent
		{
			var uiComponent:UIComponent;
			
			if( _componentMap[type] != null )
			{
				try{
					//creating the class from the type sent in the signature
					var ClassReference:Class = getDefinitionByName( _componentMap[type] ) as Class;
				}
				catch(e:Error){
					KTrace.getInstance().log("ComponentFactory >> getComponent >> Error: class not found, " + _componentMap[type]);
				//	trace ("ComponentFactory >> getComponent >> Error: class not found");
					return null;
				}
				
				uiComponent = new ClassReference();	
			
				return uiComponent;
			}
			else
			{
				KTrace.getInstance().log("ComponentFactory >> getComponent >> Error: no class is mapped for this component name.");
			//	trace ("ComponentFactory >> getComponent >> Error: no class is mapped for this component name.");
			}
			
			return null;	
		}
	}
}