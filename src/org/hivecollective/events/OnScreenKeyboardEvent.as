package org.hivecollective.events
{
    import flash.events.Event;
    
    import org.hivecollective.ui.text.AsciiCharacter;
    
    public class OnScreenKeyboardEvent extends Event
    {
        /**
         * 
         */        
        public static const KEYBOARD_KEY_PRESS:String = "onKeyboardKeyPress";

        /**
         * 
         */
        public var character:AsciiCharacter; 
        
        /**
         * 
         * @param type
         * @param bubbles
         * @param cancelable
         * 
         */        
        public function OnScreenKeyboardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}