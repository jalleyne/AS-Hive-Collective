package org.hivecollective.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class SoundData extends Sound
	{
		public var soundTransform 		:SoundTransform = new SoundTransform();
		public var soundChannel 		:SoundChannel;
		
		public var isLoading 			:Boolean = false;
		public var isLoaded				:Boolean = false;
		
	 	private var _name 				:String;
	 	private var _URL 				:String;
		private var _URLRequest		:URLRequest;
		
		public function SoundData( URL:URLRequest, name:String=null )
		{
			super();
			_name = name || mkName();
            _URLRequest = URL;
		}
		
		public var loops:int = 0;
		
		override public function play( startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null ):SoundChannel
		{
			if( Capabilities.hasAudio ){
				soundChannel = super.play( startTime, loops, sndTransform );
				soundChannel.addEventListener( Event.SOUND_COMPLETE, soundComplete, false, 0, true );
				
				return soundChannel;
			}
			else return null;
		}
		
		private function soundComplete( e:Event ):void
		{
			soundChannel.removeEventListener( Event.SOUND_COMPLETE, soundComplete );
			dispatchEvent( new Event( Event.SOUND_COMPLETE ) );
		}
		
		public function stopSound():void
		{
			if( Capabilities.hasAudio ) soundChannel.stop();
		}
		
		public function set volume( num:Number ):void
		{
			soundTransform = new SoundTransform();
			soundTransform.volume = num;
						
			if( Capabilities.hasAudio ) 
			soundChannel.soundTransform = soundTransform;
		}
		
		public function get volume( ):Number
		{
			return soundTransform.volume;
		}
		
		// prop to use with tweenLite to bypass tween volume proxy
		public function set vol( num:Number ):void
		{
			volume = num;
		}
		
		public function get vol( ):Number
		{
			return volume;
		}
		
		//DATA
		public function get URL():URLRequest
		{
			return _URLRequest;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		
        // staiic helpers
        private static var _sndCount:int=0;
        private static function mkName():String
        {
            return 'sound'+(++_sndCount);
        }
	}
}