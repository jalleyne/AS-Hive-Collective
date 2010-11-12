package org.hivecollective.framework.managers.plugins
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import org.hivecollective.framework.HiveFramework;
	import org.hivecollective.framework.managers.Manager;
	import org.hivecollective.framework.sequence.Sequence;
	import org.hivecollective.sound.SoundData;
	
	public class SoundManager extends Manager
	{	
	    
	    /**
	     * 
	     * @param hive
	     * 
	     */	    
	    public function SoundManager( hive:HiveFramework )
	    {
	        super(hive);
	        init(hive);
	    }
		
		//_________________________________________________________________________________________________ REGISTER CONTROLLER
		
		/**
		 * 
		 * @param hive
		 * @return 
		 * 
		 */		
		protected function init(hive:HiveFramework):SoundManager
		{
				
            if(HiveFramework.DEBUG_MODE){trace( "LayoutManager :: init" )}

            //var manager:SoundManager = new SoundManager(hive);
            hive.registerManager(this);
            
            //_____________ Register Object :: SoundData
            function conditionalFunction( action:*, sequence:Sequence, positionInSequence:int ):void {
            	SoundData(action).play();
            }
            hive.sequenceManager.registerAction(SoundData, conditionalFunction);
            
            SOUNDS 			= new Array();
            SOUNDS_BY_NAME	= new Dictionary( true );
            SOUND_TRANSFORM = new SoundTransform();
            
            _currentVolume              = SOUND_TRANSFORM.volume;
            SoundMixer.soundTransform   = SOUND_TRANSFORM;
				
            return this;
		}
		
		
		
		//_________________________________________________________________________________________________ MODEL
		
		/**
		 * 
		 */		
		private var SOUNDS				:Array;
		/**
		 * 
		 */		
		private var SOUNDS_BY_NAME		:Dictionary;
		/**
		 * 
		 */		
		private var SOUND_TRANSFORM 	:SoundTransform;
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get sounds():Array
		{
		    return SOUNDS;
		}
		
		/**
		 * 
		 * @param args
		 * 
		 */		
		public function add( ...args ):void
		{
			for (var i:Number = 0; i < args.length; i++) {
				SOUNDS_BY_NAME[ args[i].name ] = args[i];
				SOUNDS.push(args[i]);
		    }
		}
		
		/**
		 * 
		 * @param sound
		 * 
		 */		
		public function remove( sound:* ):void
		{
			delete SOUNDS[ SOUNDS.indexOf(sound) ];
			delete SOUNDS_BY_NAME[ sound.name ];
		}
		
		/**
		 * 
		 * @param names
		 * 
		 */		
		public function removeByName( ...names ):void
		{
			for (var i:int = 0; i < names.length; i++) {
		        remove( getSoundByName( names[i] ) )
		    }
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getSoundByName( name:String ):SoundData
		{
			return SOUNDS_BY_NAME[ name ];
		}
		
		
		
		
		
		//_________________________________________________________________________________________________ VIEW
		
		/**
		 * 
		 */		
		private var _currentVolume	:int; 
		
		/**
		 * 
		 * @param num
		 * 
		 */		
		public function set volume( num:Number ):void
		{
			SOUND_TRANSFORM = new SoundTransform( );
			SOUND_TRANSFORM.volume = _currentVolume = num;
			SoundMixer.soundTransform = SOUND_TRANSFORM;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get volume( ):Number
		{
			return SOUND_TRANSFORM.volume;
		}
		/**
		 * 
		 * @param num
		 * 
		 */		
		public function set vol( num:Number ):void
		{
			volume = num;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get vol( ):Number
		{
			return volume;
		}
		
		/**
		 * 
		 * @param num
		 * 
		 */
		public function set pan( num:Number ):void
		{
			SOUND_TRANSFORM.pan = num;
			SoundMixer.soundTransform = SOUND_TRANSFORM;
		}
		
		/**
		 * 
		 * 
		 */
		public function mute():void
		{	
			_currentVolume = SOUND_TRANSFORM.volume;
            SOUND_TRANSFORM.volume = 0;
		}
		/**
		 * 
		 * 
		 */		
		public function unmute( ):void
		{
		    SOUND_TRANSFORM.volume = _currentVolume;
		}
		/**
		 * 
		 * 
		 */		
		private function fadeSound( ):void
		{
			SoundMixer.soundTransform = SOUND_TRANSFORM;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get hasAudio():Boolean {
			return Capabilities.hasAudio;
		}
		
	}
}