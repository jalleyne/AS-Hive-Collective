package org.hivecollective.ui.controls
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    public class BasicHSlider extends Sprite
    {
        public var handle:Sprite;
        
        public var track:Sprite;
        
        private var dRect:Rectangle;
        
        public function BasicHSlider()
        {
            super();
            init();
        }
        

        private function init():void
        {
            dRect = new Rectangle( 0+(handle.width>>1), 0, track.width-handle.width, 0 );
            
            addEvents();
        }
        
        private function dispatchChange(e:Event):void
        {
            dispatchEvent( new Event( Event.CHANGE, true ) );
        }
        
        private function onHandleUp( e:MouseEvent ):void
        {
            handle.stopDrag();
            stage.removeEventListener( MouseEvent.MOUSE_UP, onHandleUp );
            stage.removeEventListener( MouseEvent.MOUSE_MOVE, dispatchChange );
        }
        
        private function onHandleDown( e:MouseEvent ):void
        {
            handle.startDrag( true, dRect );
            stage.addEventListener( MouseEvent.MOUSE_UP, onHandleUp, false, 0, true );
            stage.addEventListener( MouseEvent.MOUSE_MOVE, dispatchChange, false, 0, true );
        }
        
        
        private function addEvents():void
        {
            handle.addEventListener( MouseEvent.MOUSE_DOWN, onHandleDown, false, 0, true );
        }
        
        private function removeEvents():void
        {
            handle.removeEventListener( MouseEvent.MOUSE_DOWN, onHandleDown );
        }
        
        
        
        public function set value( val:Number ):void
        {
            handle.x = Math.min( 1, val ) * dRect.width;
        }
        
        public function get value():Number
        {
            return handle.x/dRect.width;
        }
        
        
    }
}