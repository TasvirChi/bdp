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
package com.borhan.vo
{
	import com.borhan.vo.BorhanDropFolder;

	[Bindable]
	public dynamic class BorhanWebexDropFolder extends BorhanDropFolder
	{
		/**
		**/
		public var webexUserId : String = null;

		/**
		**/
		public var webexPassword : String = null;

		/**
		**/
		public var webexSiteId : int = int.MIN_VALUE;

		/**
		**/
		public var webexPartnerId : String = null;

		/**
		**/
		public var webexServiceUrl : String = null;

		/**
		**/
		public var webexHostIdMetadataFieldName : String = null;

		/**
		**/
		public var categoriesMetadataFieldName : String = null;

		/**
		* @see com.borhan.types.borhanBoolean
		**/
		public var enforceEntitlement : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('webexUserId');
			arr.push('webexPassword');
			arr.push('webexSiteId');
			arr.push('webexPartnerId');
			arr.push('webexServiceUrl');
			arr.push('webexHostIdMetadataFieldName');
			arr.push('categoriesMetadataFieldName');
			arr.push('enforceEntitlement');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
