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
package com.borhan.commands.document
{
		import com.borhan.vo.BorhanResource;
	import com.borhan.delegates.document.DocumentUpdateContentDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Replace content associated with the given document entry.
	* 
	**/
	public class DocumentUpdateContent extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param entryId String
		* @param resource BorhanResource
		* @param conversionProfileId int
		**/
		public function DocumentUpdateContent( entryId : String,resource : BorhanResource,conversionProfileId : int=int.MIN_VALUE )
		{
			service= 'document';
			action= 'updateContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
				keyValArr = borhanObject2Arrays(resource, 'resource');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentUpdateContentDelegate( this , config );
		}
	}
}
