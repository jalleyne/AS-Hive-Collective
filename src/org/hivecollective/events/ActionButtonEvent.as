package org.hivecollective.events
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class ActionButtonEvent extends Event
    {
        
        private var _mouseEvent:MouseEvent;
        
        public function get mouseEvent():MouseEvent
        {
            return _mouseEvent;
        }
        
        public function ActionButtonEvent(type:String, mouseEvent:MouseEvent, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            //TODO: implement function
            super(type, bubbles, cancelable);
            _mouseEvent = mouseEvent;
        }
    }
}