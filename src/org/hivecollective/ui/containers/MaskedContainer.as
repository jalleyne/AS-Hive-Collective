package org.hivecollective.ui.containers
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class MaskedContainer extends Sprite
    {
        public function MaskedContainer(size:Rectangle=null)
        {
            super();
            init(size);
        }
        
        private function init(size:Rectangle):void
        {
            _maskSize = size || _maskSize;
            addEventListener( Event.ADDED_TO_STAGE, onAdded, false, 0, true );
            addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true );
        }
        
        private function onAdded(e:Event):void
        {
            if( (!_maskClip || _maskClip.parent != parent) ){
                mask = _maskClip || drawMask(_maskSize);
                parent.addChild(_maskClip);
            }
        }
        
        private function onRemoved(e:Event):void
        {
            if( _maskClip.parent )
            _maskClip.parent.removeChild(_maskClip);
        }
        
        private function drawMask(rect:Rectangle):Shape
        {
            _maskClip = _maskClip || new Shape();
            var g:Graphics = _maskClip.graphics;
            g.clear();
            g.beginFill(Math.random()*0xFF);
            g.drawRect(rect.x,rect.y,rect.width,rect.height);
            return _maskClip;
        }
        
        private var _maskSize:Rectangle = new Rectangle(0,0,200,200);
        public function set maskSize(val:Rectangle):void
        {
            _maskSize = val;
            drawMask(_maskSize);
        }
        
        public function get maskSize():Rectangle
        {
            return _maskSize;
        }

        private var _maskClip:Shape;
        override public function addChild(child:DisplayObject):DisplayObject
        {
            super.addChild(child);
            
            if( parent ) parent.addChild(_maskClip);
            return child;
        }
        
        override public function addChildAt(child:DisplayObject,index:int):DisplayObject
        {
            super.addChildAt(child, index);
            
            if( parent ) parent.addChild(_maskClip);
            return child;
        }
        
        
    }
}