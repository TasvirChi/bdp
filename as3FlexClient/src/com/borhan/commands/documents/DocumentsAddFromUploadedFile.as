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
package com.borhan.commands.documents
{
		import com.borhan.vo.BorhanDocumentEntry;
	import com.borhan.delegates.documents.DocumentsAddFromUploadedFileDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Add new document entry after the specific document file was uploaded and the upload token id exists
	* 
	**/
	public class DocumentsAddFromUploadedFile extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param documentEntry BorhanDocumentEntry
		* @param uploadTokenId String
		**/
		public function DocumentsAddFromUploadedFile( documentEntry : BorhanDocumentEntry,uploadTokenId : String )
		{
			service= 'document_documents';
			action= 'addFromUploadedFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = borhanObject2Arrays(documentEntry, 'documentEntry');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsAddFromUploadedFileDelegate( this , config );
		}
	}
}
