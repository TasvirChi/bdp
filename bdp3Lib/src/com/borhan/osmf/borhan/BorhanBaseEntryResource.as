package com.borhan.osmf.borhan
{
	import com.borhan.vo.BorhanBaseEntry;
	
	import org.osmf.media.MediaResourceBase;

	public class BorhanBaseEntryResource extends MediaResourceBase
	{
		public var entry:BorhanBaseEntry;
		
		public function BorhanBaseEntryResource(_entry:BorhanBaseEntry)
		{
			entry = _entry;
		}

	}
}
