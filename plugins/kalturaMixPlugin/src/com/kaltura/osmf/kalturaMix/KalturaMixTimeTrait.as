package com.borhan.osmf.borhanMix
{
	import com.borhan.components.players.eplayer.Eplayer;
	import com.borhan.components.players.events.PlayerEvent;
	
	import org.osmf.events.SeekEvent;
	import org.osmf.traits.TimeTrait;

	public class BorhanMixTimeTrait extends TimeTrait
	{
		public var eplayer:Eplayer;

		public function BorhanMixTimeTrait(_eplayer:Eplayer, duration:Number=NaN)
		{
			super(duration);
			eplayer = _eplayer;
			eplayer.addEventListener(PlayerEvent.ROUGHCUT_PLAY_END,onRoughCutEnd);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function get currentTime():Number
		{
			return eplayer.playheadTime;
		}
		
		public function setSuperDuration(value:Number):void
		{
			setDuration(value);
		}
		public function onRoughCutEnd (evt:PlayerEvent) : void
		{
			signalComplete();
		}
		
	}
}