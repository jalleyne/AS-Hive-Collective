package org.hivecollective.ui.controls
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.text.TextField;
    /**
     * 
     * @author jovan
     * 
     */    
    public class TextInput extends Sprite
    {
        public var defaultText:String;
        
        /**
         * 
         */        
        protected var focusShape:DisplayObject;
        /**
         * 
         */        
        protected var inputField:TextField;
        /**
         * 
         * 
         */        
        public function TextInput()
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
            //
            focusShape = this["focus"];
            if(focusShape)
                removeChild(focusShape);
            
            //
            inputField = this["input"];
            if(inputField){
                inputField.addEventListener(FocusEvent.FOCUS_IN,onFocusIn,false,0,true);
                inputField.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut,false,0,true);
            }
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onFocusIn(e:FocusEvent):void
        {
            addChildAt(focusShape,1);
            
            if( inputField.text == defaultText )
                inputField.text = "";
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onFocusOut(e:FocusEvent):void
        {
            if(focusShape.parent)
                removeChild(focusShape);
            
            if( !inputField.text.length )
                inputField.text = defaultText;
        }
        
        /**
         * 
         * @return 
         * 
         */        
        public function get text():String
        {
            return inputField.text;
        }
        /**
         * 
         * @param val
         * 
         */        
        public function set text(val:String):void
        {
            inputField.text = val;
        }
        
    }
}