/*****************************************************
*  
*  Copyright 2010 Eyewonder, LLC.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Eyewonder, LLC.
*  Portions created by Eyewonder, LLC. are Copyright (C) 2010 
*  Eyewonder, LLC. A Limelight Networks Business. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.vast.parser.base
{	
	/**
	 * Internal linear creative parser and data object
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	 
	
	public dynamic class VAST2LinearElement extends VAST2Element
	{
		private var _videoDuration:VAST2Time;
		private var _apiFramework:String;
		private var _MediaFiles:Array;
		private var _ClickThrough:String;
		private var _CustomClick:Array;
		private var _CustomClickIds:Array;
		private var _AdParameters:String;
		private var _icons:Array;
		
		public function VAST2LinearElement(forxData:Object, trackingData:VAST2TrackingData)	
		{
			super(forxData,"VAST2LinearElement",trackingData);
			//UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " created", "Instream", elementName); 
			
			_videoDuration = new VAST2Time();
			_apiFramework = new String();
			_MediaFiles = new Array();
			_ClickThrough = new String();
			_CustomClick = new Array();
			_icons = new Array();
			
			if ( forxData == null || _trackingData == null)
			{
				//UIFDebugMessage.getInstance()._debugMessage(3, "Element" + elementName + " is just a temporary placeholder.", "Instream", elementName); 	
				return;		// Just a placeholder object to prevent null reference errors
			}
			
		}
			
		
		
		
		/**
		 * @private
		 */	
		public function parseXMLData() : void
		{
		
			var i:Number;
			var j:Number;
			
			if (_forxRef == null || _trackingData == null)
				return;
				
			// Less code (and faster) than doing a switch inside the for trackingEvents loop
			var eventMap:Array = new Array();
			eventMap["start"] = _trackingData.trkStartEvent;
			eventMap["midpoint"] = _trackingData.trkMidPointEvent;
			eventMap["firstQuartile"] = _trackingData.trkFirstQuartileEvent;
			eventMap["thirdQuartile"] = _trackingData.trkThirdQuartileEvent;
			eventMap["complete"] = _trackingData.trkCompleteEvent;
			eventMap["mute"] = _trackingData.trkMuteEvent;
			eventMap["pause"] = _trackingData.trkPauseEvent;
			eventMap["replay"] = _trackingData.trkReplayEvent;
			eventMap["fullscreen"] = _trackingData.trkFullScreenEvent;
			eventMap["exitFullscreen"] = _trackingData.trkExitFullScreenEvent;
			eventMap["close"] = _trackingData.trkCloseEvent;				
			eventMap["creativeView"] = _trackingData.trkCreativeViewEvent;
			eventMap["unmute"] = _trackingData.trkUnmuteEvent; 
			eventMap["rewind"] = _trackingData.trkRewindEvent;
			eventMap["resume"] = _trackingData.trkResumeEvent;
			eventMap["expand"] = _trackingData.trkExpandEvent;
			eventMap["collapse"] = _trackingData.trkCollapseEvent;
			eventMap["acceptInvitation"] = _trackingData.trkAcceptInvitationEvent;					
			eventMap["skip"] = _trackingData.trkSkipEvent;					
			eventMap["closeLinear"] = _trackingData.trkCloseLinearEvent;					
			eventMap["progress"] = _trackingData.trkProgressEvent;					
			eventMap["stop"] = new Array(); // Prevent breaking		
			eventMap["replay"] = new Array(); // Prevent breaking			

			for (i = 0; i < _forxRef.TrackingEvents.Tracking.length(); i++) 
			{
					
				if(_forxRef.TrackingEvents.Tracking[i] != undefined) 
				{
					var Tracking : Object = new Object();
					Tracking.event = _forxRef.TrackingEvents.Tracking[i].@event;
					Tracking.url = _forxRef.TrackingEvents.Tracking[i].text();
					if (Tracking.event.toString() == "progress")
						Tracking.offset = _forxRef.TrackingEvents.Tracking[i].@offset; 
					if (eventMap[String(Tracking.event)] != undefined)
						eventMap[String(Tracking.event)].push(Tracking);

				}
			}

			if(_forxRef.AdParameters != undefined) 
				_AdParameters = _forxRef.AdParameters.text();
			
			if(_forxRef.Duration != undefined) 
			{
				var durationArray : Array = _forxRef.Duration.text().split(":");
				_videoDuration = new VAST2Time(durationArray[0], durationArray[1], durationArray[2]);
			}
			
			if(_forxRef.VideoClicks != undefined) 
			{
				if(_forxRef.VideoClicks.ClickThrough != undefined) 
				{
						_ClickThrough = _forxRef.VideoClicks.ClickThrough.text();
				}
				//Get the clickthru tracking URLS
				processUrlList(_forxRef.VideoClicks.ClickTracking,_trackingData.clickTrackingArray);
				for(i = 0; i < _forxRef.VideoClicks.CustomClick.length(); i++) 
				{
					
					if (_forxRef.VideoClicks.CustomClick[i] != undefined) 
					{
						var customClick:Object = new Object;
						_CustomClick.url = _forxRef.VideoClicks.CustomClick.text();
						_CustomClick.id = _forxRef.VideoClicks.CustomClick.@id;
						_CustomClick.push(customClick);
					}
				}
			}
			
			if(_forxRef.MediaFiles != undefined) 
			{
				for(i = 0; i < _forxRef.MediaFiles.MediaFile.length(); i++) 
				{
					
					if (_forxRef.MediaFiles.MediaFile[i] != undefined) 
					{
					
							var Mediafile : Object = new Object();
							Mediafile.url = _forxRef.MediaFiles.MediaFile[i].text();
							Mediafile.delivery = _forxRef.MediaFiles.MediaFile[i].@delivery;
							Mediafile.bitrate = _forxRef.MediaFiles.MediaFile[i].@bitrate;
							Mediafile.type = _forxRef.MediaFiles.MediaFile[i].@type;
							Mediafile.width = _forxRef.MediaFiles.MediaFile[i].@width;
							Mediafile.height = _forxRef.MediaFiles.MediaFile[i].@height;
							Mediafile.id = _forxRef.MediaFiles.MediaFile[i].@id;
							Mediafile.scalable = _forxRef.MediaFiles.MediaFile[i].@scalable;
							Mediafile.maintainAspectRatio = _forxRef.MediaFiles.MediaFile[i].@maintainAspectRatio;
							Mediafile.apiFramework = _forxRef.MediaFiles.MediaFile[i].@apiFramework;
							
							_MediaFiles.push(Mediafile);

					
					}
				}
			}
			
			if(_forxRef.Icons != undefined) 
			{
				for (i = 0; i < _forxRef.Icons.Icon.length(); i++) 
				{
					
					if(_forxRef.Icons.Icon[i] != undefined) 
					{
						var icon : Object = new Object();
						icon.program = _forxRef.Icons.Icon[i].@program.toString();
						icon.width = _forxRef.Icons.Icon[i].@width.toString();
						icon.height = _forxRef.Icons.Icon[i].@height.toString();
						icon.xPosition = _forxRef.Icons.Icon[i].@xPosition.toString();
						icon.yPosition = _forxRef.Icons.Icon[i].@yPosition.toString();
						icon.apiFramework = _forxRef.Icons.Icon[i].@apiFramework.toString();
						icon.offset = _forxRef.Icons.Icon[i].@offset.toString();
						icon.duration = _forxRef.Icons.Icon[i].@duration.toString();
						if ( _forxRef.Icons.Icon[i].StaticResource != undefined)
							icon.staticResource = _forxRef.Icons.Icon[i].StaticResource.text().toString();
						else if (_forxRef.Icons.Icon[j].HTMLResource != undefined)
							icon.htmlResource = _forxRef.Icons.Icon[i].HTMLResource.text().toString();
						else if (_forxRef.Icons.Icon[j].IFrameResource != undefined)
							icon.iFrameResource = _forxRef.Icons.Icon[i].IFrameResource.text().toString();
						
						if ( _forxRef.Icons.Icon[i].IconClicks != undefined)
						{
							if ( _forxRef.Icons.Icon[i].IconClicks.IconClickThrough != undefined)
								icon.clickThrough = _forxRef.Icons.Icon[i].IconClicks.IconClickThrough.text().toString();
							if (_forxRef.Icons.Icon[i].IconClicks.IconClickTracking != undefined)
								icon.clickTracking = _forxRef.Icons.Icon[i].IconClicks.IconClickTracking.text().toString();
						}
						if (_forxRef.Icons.Icon[i].IconViewTracking != undefined)
							icon.viewTracking = _forxRef.Icons.Icon[i].IconViewTracking.text().toString();
						
						_icons.push(icon);
					}
				}
			}
		}
	
		/**
		 * @private
		 */	
		public function get AdParameters():String {return _AdParameters;}
		/**
		 * @private
		 */	
		public function get videoDuration():VAST2Time {return _videoDuration;}
		/**
		 * @private
		 */	
		public function get apiFramework():String {return _apiFramework;}
		/**
		 * @private
		 */	
		public function get MediaFiles():Array {return _MediaFiles;}
		/**
		 * @private
		 */	
		public function get ClickThrough():String {return _ClickThrough;}
		/**
		 * @private
		 */	
		public function get CustomClick():Array {return _CustomClick;}
		/**
		 * @private
		 */	
		public function get icons():Array {return _icons;}
	
	}
}
