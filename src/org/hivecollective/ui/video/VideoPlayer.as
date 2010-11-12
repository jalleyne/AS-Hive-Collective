/**
 * 
 */
package org.hivecollective.ui.video
{
    import fl.video.FLVPlayback;
    
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    /**
     * 
     * @author jovan
     * 
     */    
    public class VideoPlayer extends Sprite
    {
        /**
         * 
         */        
        public var player:FLVPlayback;
        /**
         * 
         */        
        public var playButton:Sprite;
        /**
         * 
         */        
        public var pauseButton:Sprite;
        /**
         * 
         */        
        public var fullscreenButton:Sprite;
        /**
         * 
         */        
        public var muteButton:MovieClip;
        /**
         * 
         */        
        public var progressTrackbar:MovieClip;
        /**
         * 
         */        
        public var controlsBackground:MovieClip;
        /**
         * 
         * 
         */        
        public function VideoPlayer()
        {
            super();
            init();
        }
        /**
         * 
         * 
         */        
        protected function init():void
        {
            if(parent is Stage){
                
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align     = StageAlign.TOP;
                
                initFromObject(loaderInfo.parameters);
            }
            
            
        }
        /**
         * 
         * @param obj
         * 
         */        
        public function initFromObject(obj:Object):void
        {
            if( obj.source != undefined )   source      = obj.source;
            if( obj.autoPlay != undefined ) autoPlay    = obj.autoPlay=='true'?true:false;
            
            if( autoPlay ) player.playWhenEnoughDownloaded();
        }
        /**
         * 
         * @param val
         * 
         */        
        public function set source(val:String):void
        {
            player.source = val;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get source():String
        {
            return player.source;
        }
        /**
         * 
         * @param val
         * 
         */        
        public function set autoPlay(val:Boolean):void
        {
            player.autoPlay = val;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get autoPlay():Boolean
        {
            return player.autoPlay;
        }
        
    }
}