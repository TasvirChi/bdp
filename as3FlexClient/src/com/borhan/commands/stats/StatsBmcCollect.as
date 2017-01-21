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
package com.borhan.commands.stats
{
		import com.borhan.vo.BorhanStatsBmcEvent;
	import com.borhan.delegates.stats.StatsBmcCollectDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Will collect the bmcEvent sent form the BMC client
	* // this will actually be an empty function because all events will be sent using GET and will anyway be logged in the apache log
	* 
	**/
	public class StatsBmcCollect extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param bmcEvent BorhanStatsBmcEvent
		**/
		public function StatsBmcCollect( bmcEvent : BorhanStatsBmcEvent )
		{
			service= 'stats';
			action= 'bmcCollect';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = borhanObject2Arrays(bmcEvent, 'bmcEvent');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StatsBmcCollectDelegate( this , config );
		}
	}
}
