package com.borhan.bdpfl.plugin.component
{
	//import com.borhan.bdpfl.component.IComponent;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;	
	
	public class Plymedia extends Sprite //implements IComponent
	{
		public function Plymedia()
		{			
		}

		public function initialize():void
		{
		}
		
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function set plymedia(value:Object):void
		{
			addChild(value as DisplayObject);					
		}			
	}
}