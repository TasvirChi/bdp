package com.borhan.osmf.borhanMix
{
	import com.borhan.components.players.eplayer.Eplayer;
	import com.borhan.components.players.events.PlayerBufferEvent;
	import com.borhan.components.players.states.BufferStatuses;
	
	import org.osmf.traits.BufferTrait;

	public class BorhanMixBufferTrait extends BufferTrait
	{
		public var eplayer:Eplayer;

		public function BorhanMixBufferTrait(_eplayer:Eplayer)
		{
			eplayer = _eplayer;
			
			//This is a hack - since mixes do not buffer via the OSMF but through the eplayer,
			//I have given the bufferTrait a garbage bufferLength value.
			setBufferLength(10);
			super();
			
			eplayer.addEventListener(PlayerBufferEvent.PLAYER_BUFFER_STATUS, onBufferStatus);
		}
		
		private function onBufferStatus(e:PlayerBufferEvent):void
		{
			setBuffering(e.bufferingStatus == BufferStatuses.BUFFERING);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			eplayer.removeEventListener(PlayerBufferEvent.PLAYER_BUFFER_STATUS, onBufferStatus);
		}
	}
}