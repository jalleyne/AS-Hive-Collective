package org.hivecollective.ui.controls
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Elastic;
    
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    
    import org.hivecollective.events.ActionButtonEvent;
    /**
     * 
     * @author jovan
     * 
     */    
    public class BasicButton extends MovieClip
    {
        /**
         * 
         */        
        public var base:MovieClip;
        /**
         * 
         * 
         */        
        public function BasicButton()
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
            mouseChildren   = false;
            buttonMode      = true;
            
            addEventListener(MouseEvent.MOUSE_OVER, onRollOver, false,0,true);
            addEventListener(MouseEvent.MOUSE_OUT,  onRollOut,  false,0,true);
            addEventListener(MouseEvent.CLICK,      onClick,    false,0,true);
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onClick(e:MouseEvent):void
        {
            var evt:String = this.toString().replace("[object ","").replace("]","");
            dispatchEvent(new ActionButtonEvent(evt,e,true));
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onRollOver(e:MouseEvent):void
        {
            //TODO: implement function
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onRollOut(e:MouseEvent):void
        {
            //TODO: implement function
        }
    }
}