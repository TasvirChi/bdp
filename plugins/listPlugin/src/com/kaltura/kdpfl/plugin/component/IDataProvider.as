package com.borhan.bdpfl.plugin.component
{

import flash.events.IEventDispatcher;
	
	
public interface IDataProvider extends IEventDispatcher
{
	
	function set selectedIndex( index:Number ):void;
	function get selectedIndex():Number;
			
}
}