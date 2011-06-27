﻿/**
 WvNetConnection
 version 1.1
 03/08/2010
 Widevine extension to the NetConnection class.  Required to stream encrypted content.
**/

package com.kaltura.kdpfl.plugin.widevine
{
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import flash.net.NetConnection;
	import flash.events.*;
	
	public class WvNetConnection extends NetConnection 
	{
		// URL passed in by swf
		private var myOrigURL:String;
		// URL used during connect() call.
		private var myNewURL:String;
		private var myMovie:String;
		private var myErrorText:String;
		private var myIsConnected:Boolean;
		private var myMediaTime:Number;
		private var myPlayScale:Number;
		// bypass Widevine client
		private var myIsBypassMode:Boolean;
		// progressive download
		private var myIsPdl:Boolean;
		
		public function WvNetConnection():void
		{
			this.objectEncoding = flash.net.ObjectEncoding.AMF0;
			myIsConnected 	= false;
			myIsBypassMode 	= false;
			myIsPdl	   		= true;
			myMediaTime 	= 0;
			myPlayScale 	= 1;
		}
		///////////////////////////////////////////////////////////////////////////
		public override function connect(command:String, ... arguments):void
		{
			// handle RTMP streaming, not supported in Widevine yet
			if (command.substr(0, 4) == "rtmp") {
				myIsPdl = false;
			}

			if (IsBypassMode()) {
				try {
					if (IsPdl()) {
						//trace("(bypass) Handling HTTP stream:" + command);
						super.connect(null);
						myNewURL = command;
					}
					else {
						// RTMP streaming
						//trace("(bypass) Handling RTMP stream:" + command);
						myNewURL = command.substring(0, command.lastIndexOf("/")+1);
						super.connect(myNewURL);
					}
				}
				catch (e:Error) {
					//dispatchEvent(new NetStatusEvent("onNetStatus", obj));
					//trace("WvNetStream.connect() error:" + e.message);
					throw new Error("connect() failed");	
				}
				return;
			}
			
			// Widevine encrypted stream only 
			if (IsPdl()) {
				//trace("(Handling Wv HTTP stream:" + command);
			}
			else {
				command = command.substring(0, command.lastIndexOf("/")+1);
				//trace("(Handling Wv RTMP stream:" + command);
			}
			if (doConnect(command) != 0) {
				//dispatchEvent(new NetStatusEvent("netStatus", obj));
				throw new Error("doConnect() failed");	
			}
		}		
		///////////////////////////////////////////////////////////////////////////
		function doConnect(theURL:String):Number
		{
			myOrigURL = theURL;
			if (myOrigURL == null) {
				myErrorText = "url passed in connect() is null";
				return 1;
			}
			
			try {
				myMovie = theURL.substr(myOrigURL.lastIndexOf("/")+1);
				myNewURL = String(ExternalInterface.call("WVGetURL", myOrigURL));
	
				if (myNewURL.substr(0,6) == "error:") {
					myErrorText = myNewURL;
					return 2;
				}
			}
			catch (errObject:Error) {
				myErrorText = "WVGetURL() failed. " + errObject.message;
			}
			try {
				//trace("Calling super.connect()");
				super.connect(myNewURL);
			}
			catch (errObject:Error) {
				myErrorText = "super.connect() failed. " + errObject.message;
			}
			myIsConnected = true;
			return 0;
		}	
		///////////////////////////////////////////////////////////////////////////
		public override function close():void
		{
			trace("WvNetConnection.close()");
			myIsConnected = false;
			super.close();
		}
		///////////////////////////////////////////////////////////////////////////
		public function getErrorText():String
		{
			return myErrorText;
		}
		///////////////////////////////////////////////////////////////////////////
		public function getNewURL():String
		{
			return myNewURL;
		}
		///////////////////////////////////////////////////////////////////////////
		public function isConnected():Boolean
		{
			return myIsConnected;
		}
		///////////////////////////////////////////////////////////////////////////
		public function setBypassMode(flag:Boolean)
		{
			myIsBypassMode = flag;
		}
		///////////////////////////////////////////////////////////////////////////
		public function IsBypassMode():Boolean
		{
			return myIsBypassMode;
		}
		///////////////////////////////////////////////////////////////////////////
		public function IsPdl():Boolean
		{
			return myIsPdl;
		}
	}  // class
}  // package