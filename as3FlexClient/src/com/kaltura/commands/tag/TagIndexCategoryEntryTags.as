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
package com.borhan.commands.tag
{
	import com.borhan.delegates.tag.TagIndexCategoryEntryTagsDelegate;
	import com.borhan.net.BorhanCall;

	/**
	**/
	public class TagIndexCategoryEntryTags extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param categoryId int
		* @param pcToDecrement String
		* @param pcToIncrement String
		**/
		public function TagIndexCategoryEntryTags( categoryId : int,pcToDecrement : String,pcToIncrement : String )
		{
			service= 'tagsearch_tag';
			action= 'indexCategoryEntryTags';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('categoryId');
			valueArr.push(categoryId);
			keyArr.push('pcToDecrement');
			valueArr.push(pcToDecrement);
			keyArr.push('pcToIncrement');
			valueArr.push(pcToIncrement);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new TagIndexCategoryEntryTagsDelegate( this , config );
		}
	}
}
