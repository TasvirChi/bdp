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
package com.borhan.commands.playlist
{
		import com.borhan.vo.BorhanPlaylistFilter;
		import com.borhan.vo.BorhanFilterPager;
	import com.borhan.delegates.playlist.PlaylistListDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* List available playlists
	* 
	**/
	public class PlaylistList extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param filter BorhanPlaylistFilter
		* @param pager BorhanFilterPager
		**/
		public function PlaylistList( filter : BorhanPlaylistFilter=null,pager : BorhanFilterPager=null )
		{
			service= 'playlist';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			if (filter) { 
				keyValArr = borhanObject2Arrays(filter, 'filter');
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
			delegate = new PlaylistListDelegate( this , config );
		}
	}
}
