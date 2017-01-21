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
package com.borhan.commands.varConsole
{
		import com.borhan.vo.BorhanPartnerFilter;
		import com.borhan.vo.BorhanReportInputFilter;
		import com.borhan.vo.BorhanFilterPager;
	import com.borhan.delegates.varConsole.VarConsoleGetPartnerUsageDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Function which calulates partner usage of a group of a VAR's sub-publishers
	* 
	**/
	public class VarConsoleGetPartnerUsage extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param partnerFilter BorhanPartnerFilter
		* @param usageFilter BorhanReportInputFilter
		* @param pager BorhanFilterPager
		**/
		public function VarConsoleGetPartnerUsage( partnerFilter : BorhanPartnerFilter=null,usageFilter : BorhanReportInputFilter=null,pager : BorhanFilterPager=null )
		{
			service= 'varconsole_varconsole';
			action= 'getPartnerUsage';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			if (partnerFilter) { 
				keyValArr = borhanObject2Arrays(partnerFilter, 'partnerFilter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			if (usageFilter) { 
				keyValArr = borhanObject2Arrays(usageFilter, 'usageFilter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			if (pager) { 
				keyValArr = borhanObject2Arrays(pager, 'pager');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new VarConsoleGetPartnerUsageDelegate( this , config );
		}
	}
}
