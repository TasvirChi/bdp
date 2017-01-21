package com.borhan.bdpfl.model.vo
{
	import com.borhan.vo.BorhanUiConf;
	import com.borhan.vo.BorhanWidget;
	
	/**
	 * Class ConfigVO holds parameters related to the general configuration of the BDP. 
	 * 
	 */	
	public class ConfigVO
	{
		/**
		 * Parameter holds the flashvars passed to the BDP.
		 */		
		public var flashvars:Object;
		/**
		 * Parameter holds the information on the current BorhanWidget
		 */		
		public var kw : BorhanWidget; 
		/**
		 * Parameter to hold the Uiconf object of the player.
		 */		
		public var kuiConf : BorhanUiConf;
		/**
		 * A unique ID for the loaded instance of the BDP. 
		 */		
		public var sessionId : String;
	}
}