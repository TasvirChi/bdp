package com.borhan.bdpfl.model
{
	import com.borhan.BorhanClient;
	import com.borhan.config.BorhanConfig;
	import com.borhan.bdpfl.model.vo.ServicesVO;
	
	import flash.net.URLLoader;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 *  Class ServicesProxy manages the parameters related to Borhan services, i.e, creating a BorhanClient, BorhanConfig, etc.
	 * 
	 */	
	public class ServicesProxy extends Proxy
	{
		public static const NAME:String = "servicesProxy";
		
		
		//DEPRECATED
		public var borhanClient : BorhanClient;
		
		//public static const CONFIG_SERVICE:String = "configService";
		private var _configService:URLLoader;
		/**
		 * Constructor 
		 * 
		 */			
		public function ServicesProxy()
		{
			super(NAME, new ServicesVO());
		}
		/**
		 * constructs a new BorhanClient based on a BorhanConfig object.
		 * @param config object of type BorhanConfig used to construct the BorhanClient
		 * 
		 */		
		public function createClient( config : BorhanConfig ) : void
		{
			this.vo.borhanClient = new BorhanClient( config );
			borhanClient = this.vo.borhanClient;
			
		}
		
		public function get vo () : ServicesVO
		{
			return this.data as ServicesVO;
		}
			
		
		
		
		
		
		
	}
}