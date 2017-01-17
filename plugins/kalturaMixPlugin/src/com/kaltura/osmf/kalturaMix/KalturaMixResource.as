package com.borhan.osmf.borhanMix
{
	import com.borhan.vo.BorhanMixEntry;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;

	public class BorhanMixResource implements IMediaResource
	{
		public var entry:BorhanMixEntry;
		
		public function BorhanMixResource(_entry:BorhanMixEntry)
		{
			entry = _entry;
		}

		public function get metadata():Metadata
		{
			return null;
		}
		
	}
}