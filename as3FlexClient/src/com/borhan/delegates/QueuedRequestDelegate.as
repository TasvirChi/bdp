// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Borhan Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Borhan Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.borhan.delegates {
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.QueuedRequest;
	import com.borhan.config.BorhanConfig;
	import com.borhan.errors.BorhanError;
	import com.borhan.net.BorhanCall;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class QueuedRequestDelegate extends WebDelegateBase {

		public function QueuedRequestDelegate(call:BorhanCall = null, config:BorhanConfig = null) {
			super(call, config); 
		}
		
		override public function parse( result : XML ) : *
		{
			var resArr : Array = new Array();
			var resInd:int = 0;	// index for scanning result
			for ( var i:int=0; i<(call as QueuedRequest).calls.length; i++ )
			{
				var callClassName : String = getQualifiedClassName( (call as QueuedRequest).calls[i] );
				var commandName : String = callClassName.split("::")[1];
				var packageArr : Array =  (callClassName.split("::")[0]).split(".");
				var importFrom : String = packageArr[packageArr.length-1];
				
				var clsName : String ;
				var cls : Class;
				var myInst : Object;
				
				if (commandName == "MultiRequest") {
					clsName = "com.borhan.delegates.MultiRequestDelegate"; 
					cls = getDefinitionByName( clsName ) as Class;
					myInst = new cls(null , null);
					// set the call after the constructor, so we don't fire execute()
					myInst.call = (call as QueuedRequest).calls[i];
				}
				else {
					clsName = "com.borhan.delegates."+importFrom+"."+ commandName +"Delegate"; //'com.borhan.delegates.session.SessionStartDelegate'
					cls = getDefinitionByName( clsName ) as Class;//(') as Class;
					myInst = new cls(null , null);
				}
				
				
				//build the result as a regular result
				var xml : String = "<result><result>";
				if (commandName == "MultiRequest") {
					// add as many items as the multirequest had
					var nActions:int = ((call as QueuedRequest).calls[i] as MultiRequest).actions.length;
					for (var j:int = 0; j<nActions ; j++) {
						xml += result.result.item[j + resInd].toXMLString();	
					}
					// skip to the result of the next call that wasn't part of the MR:
					resInd+= nActions;
				}
				else {
					xml += result.result.item[resInd].children().toXMLString();
					resInd++;
				}
				xml +="</result></result>";
				
				// add the item or a matching error:
				var kErr:BorhanError = validateBorhanResponse(xml);
				
				if (kErr == null) {
					var res : XML = new XML(xml);
					try {
						var obj : Object = (myInst as WebDelegateBase).parse( res );
						resArr.push( obj );
					} catch (e:Error) {
						kErr = new BorhanError();
						kErr.errorCode = String(e.errorID);
						kErr.errorMsg = e.message;
						resArr.push( kErr );
					}
				}
				else {
					resArr.push(kErr);
				}
			}
			
			return resArr;
		}

		
	}
}