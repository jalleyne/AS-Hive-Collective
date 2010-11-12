package org.hivecollective.ui.controls
{
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    [Event(name="scroll", type="flash.events.Event")]
    
    public class ScrollBar extends Sprite
    {
        public var handle:Sprite;
        
        protected var scrollHandle:Sprite;
        
        protected var scrollBounds:Rectangle;
        
        protected var scrollTarget:DisplayObject;
        
        protected var scrollContainer:Sprite;
        
        protected var mouseDown:Boolean = false;
        
        public function ScrollBar()
        {
            super();
            init();
        }
        
        protected function init():void
        {
            registerHandle(handle);
            scrollBounds = new Rectangle(0,0,0,height-scrollHandle.height);
            handle.visible = false;
            scrollContainer = new Sprite();
            scrollContainer.addEventListener( Event.ENTER_FRAME, onRender, false, 0, true );
        }
        
        protected function onRender(e:Event):void
        {
            updateScrollUI();
        }
        
        public function updateScrollUI():void
        {
            handle.visible = scrollTarget.height > 
                                scrollContainer.scrollRect.height ? true : false;
        }
        
        protected function registerHandle(handle:Sprite):void
        {
            scrollHandle = handle;
            scrollHandle.buttonMode = true;
            scrollHandle.y = 0;
            
            scrollHandle.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true );
        }
        
        protected function handleMouseDown(e:MouseEvent):void
        {
            mouseDown = true;
            scrollHandle.startDrag(false,scrollBounds);
            addEventListener( Event.ENTER_FRAME, onScroll );
            stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true );
        }
        
        protected function handleMouseUp(e:MouseEvent):void
        {
            mouseDown = false;
            scrollHandle.stopDrag();
        }
        
        protected function onScroll(e:Event):void
        {
            var t:Number = -((scrollHandle.y/scrollBounds.height) * (scrollTarget.height-height+handle.height));
            scrollTarget.y += (t-scrollTarget.y)/5;
            
            if( int(scrollTarget.y) == int(t) && !mouseDown )
                removeEventListener( Event.ENTER_FRAME, onScroll );
            
            dispatchEvent( new Event( Event.SCROLL, true ) );
        }
        
        public function setScrollTarget(target:DisplayObject):void
        {
            scrollTarget = target;
            
            scrollTarget.parent.addChildAt(scrollContainer, scrollTarget.parent.getChildIndex(scrollTarget));
            scrollContainer.addChild(scrollTarget);
            
            scrollContainer.y = scrollTarget.y;
            scrollTarget.y = 0;
        }
        
        public function set scrollSize(rect:Rectangle):void
        {
            scrollContainer.scrollRect = rect;
        }
    }
}