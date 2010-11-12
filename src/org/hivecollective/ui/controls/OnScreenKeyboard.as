/*          ._
*            '.			     _______ _______ ___ ___ _______ 
*     --._     \    .-.		|   |   |_     _|   |   |    ___|
*         '. .--;  /  |		|       |_|   |_|   |   |    ___|
*         ,;/ ^  |`\  /.-"".   |___|___|_______|\_____/|_______|	
*        ;' \  _/   |'    .'          code.google.com/p/as-hive
*       /    `.;I> /_.--.` )    __
*      |    .'`  .'( _.Y/`;    /  \__
*       \_.'---'`   `\  `-/`-. \__/  \__
*         /_-.`-.._ _/`\  ;-./_/  \__/  \
*        |   -./  ;.__.'`\  /  \__/  \__/
*         `--'   (._ _.'`|  \__/  \__/
*                /     ./ __/  \__/  \
*           jgs ; `--';'_/  \__/  \__/
*               `;-,-'/  \__/  \
*               ,'`   \__/  \__/
*
* Copyright 2009 (c) Jovan Alleyne, Peter Nitsch, Brandon Flowers.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 * @author	Jovan Alleyne
 * @version	1.0a
 * @since	Flash 9
 */

package org.hivecollective.ui.controls
{
    import fl.managers.FocusManager;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.utils.Dictionary;
    
    import org.hivecollective.events.ActionButtonEvent;
    import org.hivecollective.events.OnScreenKeyboardEvent;
    import org.hivecollective.ui.text.AsciiCharacter;
    import org.hivecollective.ui.text.DefaultKeyboardCharacterSet;

    /**
     * 
     * @author jovan
     * 
     */    
    public class OnScreenKeyboard extends Sprite
    {
        /**
         * 
         */        
        public static const SNAP_TOP    : String = "T";
        /**
         * 
         */        
        public static const SNAP_BOTTOM : String = "B";
        /**
         * 
         */        
        public var autoCase:Boolean = true;
        /**
         * 
         */        
        public var characterSet:Array = DefaultKeyboardCharacterSet.ASCII_TABLE;
        /**
         * 
         */
        protected var _textInputDispatcher : DisplayObjectContainer;
        /**
         * 
         */        
        protected var kbFocusManager:FocusManager;
        /**
         * 
         */        
        protected var textInputTarget : TextField;
        /**
         * 
         */        
        protected var keyboardSnap : String = SNAP_BOTTOM;
        
        /**
         * 
         * 
         */        
        public function OnScreenKeyboard()
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
        }
        /**
         * 
         * @param val
         * 
         */        
        public function set textInputDispatcher(val:DisplayObjectContainer):void
        {
            kbFocusManager          = null;
            _textInputDispatcher    = val;
            
            if(_textInputDispatcher){
                kbFocusManager = new FocusManager(_textInputDispatcher);
            }
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get textInputDispatcher():DisplayObjectContainer
        {
            return _textInputDispatcher;
        }
        
        /**
         * 
         * @param e
         * 
         */        
        protected function onKeyPress(e:OnScreenKeyboardEvent):void
        {
            var char:String = e.target.toString().replace("[object ","").replace("]","");
            
            //
            var ascii:AsciiCharacter        = characterSet[int("0x"+char)];
            var evt:OnScreenKeyboardEvent   = new OnScreenKeyboardEvent(
                                                        OnScreenKeyboardEvent.KEYBOARD_KEY_PRESS,
                                                        true
                                                    );
            evt.character = ascii;
            
            // check key commands
            switch(ascii.hexCode)
            {
                case 0x00:
                    keyboardClear();
                    break;
                
                case 0x08:
                    keyboardBackSpace();
                    break;
                
                case 0x8F:
                    keyboardFocusNext();
                    break;
                
                case 0x90:
                    keyboardFocusPrev();
                    break;
                
                default:
                    appendKeyboarKey(ascii);
                    break;
                
            }
            //
            textInputTarget.scrollH = textInputTarget.maxScrollH;
            
            // dispatch key press event for any other listeners
            dispatchEvent(evt);
        }
        
        protected function isInputTextField(obj:TextField):Boolean
        {
            return Boolean(obj && obj.type == TextFieldType.INPUT);
        }
        
        /**
         * 
         * 
         */
        protected function keyboardFocusNext():void
        {
            var fo:InteractiveObject = kbFocusManager.getNextFocusManagerComponent(true);
            if( isInputTextField(fo as TextField) ) {
                kbFocusManager.setFocus(fo);
                var t:TextField = fo as TextField;
                t.setSelection(t.length,t.length);
            }
        }
        /**
         * 
         * 
         */        
        protected function keyboardFocusPrev():void
        {
            var fo:InteractiveObject = kbFocusManager.getNextFocusManagerComponent(false);
            if( isInputTextField(fo as TextField) ) {
                kbFocusManager.setFocus(fo);
                var t:TextField = fo as TextField;
                t.setSelection(t.length,t.length);
            }
        }
        /**
         * 
         * 
         */        
        protected function keyboardClear():void
        {
            textInputTarget.text = "";
        }
        /**
         * 
         * 
         */        
        protected function keyboardBackSpace():void
        {
            var t:String = textInputTarget.text;
            if(isTextSelected()){
                textInputTarget.replaceSelectedText("");
            }else 
            {
                var ci:uint = textInputTarget.caretIndex;
                textInputTarget.text = t.substring(0,ci-1) + t.substring(ci);
                
                //
                textInputTarget.setSelection(--ci,ci);
            }
        }
        
        /**
         * 
         * @param character
         * @return 
         * 
         */
        protected function appendKeyboarKey(character:AsciiCharacter):AsciiCharacter
        {
            textInputTarget.replaceSelectedText(character.symbol);
            //
            if(autoCase){
                var t:String = uppercaseFirst(textInputTarget.text.toLowerCase());
                textInputTarget.text = uppercaseFirst(t,"-");
            }
            
            //
            var ci:uint = textInputTarget.caretIndex;
            textInputTarget.setSelection(ci,ci);
            return character;
        }
        
        protected function uppercaseFirst(val:String,seperator:String=" "):String
        {
            var t:Array = [];
            var s:Array = val.split(seperator);
            for each( var w:String in s )
                t.push(w.charAt(0).toUpperCase() + w.substr(1));
            
            return t.join(seperator);
        }
        
        /**
         * 
         * @return 
         * 
         */        
        protected function isTextSelected():Boolean
        {
            return Boolean(textInputTarget.selectionBeginIndex != textInputTarget.selectionEndIndex);
        }
        
        /**
         * 
         * @param dispatcher
         * 
         */        
        public function set trigger(dispatcher:DisplayObjectContainer):void
        {
            if(textInputDispatcher){
                textInputDispatcher.removeEventListener(FocusEvent.FOCUS_IN,    onTextInputFocusIn,true);
                textInputDispatcher.removeEventListener(FocusEvent.FOCUS_OUT,   onTextInputFocusOut,true);
                textInputDispatcher.removeEventListener(MouseEvent.CLICK,       onScreenClick,true);
            }
            
            if(dispatcher)
            {
                dispatcher.addEventListener(FocusEvent.FOCUS_IN,    onTextInputFocusIn, true, 0, true);
                dispatcher.addEventListener(FocusEvent.FOCUS_OUT,   onTextInputFocusOut,true, 0, true);
                dispatcher.addEventListener(MouseEvent.CLICK,       onScreenClick,      true, 0, true);
            }
            textInputDispatcher = dispatcher;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get trigger():DisplayObjectContainer
        {
            return textInputDispatcher;
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function onScreenClick(e:MouseEvent):void
        {
            var p:Point = localToGlobal(new Point(mouseX,mouseY));
            if( !getChildAt(0).hitTestPoint(p.x,p.y) && 
                !(e.target as TextField) ){
                try{
                    if( this.parent is Loader)
                        textInputDispatcher.removeChild(this.parent);
                    else 
                        textInputDispatcher.removeChild(this);
                }
                catch(e:Error){}
                
                kbFocusManager.setFocus(null);
            }
        }
        
        /**
         * 
         * @param e
         * 
         */        
        protected function onTextInputFocusIn(e:FocusEvent):void
        {
            if( isInputTextField(e.target as TextField) ){
                textInputTarget = e.target as TextField;
                addEventListener( OnScreenKeyboardEvent.KEYBOARD_KEY_PRESS, onKeyPress, true, 0, true );
               
                //
                positionKeyboard(snap);
                
                //
                if( this.parent is Loader)
                    textInputDispatcher.addChild(this.parent);
                else 
                    textInputDispatcher.addChild(this);
            }
        }
        /**
         * 
         * @param val
         * 
         */        
        public function positionKeyboard(val:*):void
        {
            if( val is Function ){
                var func:Function = val as Function;
                y = func(this);
            }
            else {
                switch(val)
                {
                    case SNAP_TOP:
                        y = 0;
                        break;
                    
                    case SNAP_BOTTOM:
                        var r:Rectangle = textInputDispatcher.getRect(null);
                        y = (r.y + r.height) - height;
                        break;
                    
                    default:
                        break;
                }
            }
        }
        
        /**
         * 
         * @param e
         * 
         */        
        protected function onTextInputFocusOut(e:FocusEvent):void
        {
            if( !(e.relatedObject as OnScreenKeyboardKey) ){
                
                removeEventListener( OnScreenKeyboardEvent.KEYBOARD_KEY_PRESS, onKeyPress );
                
                try{
                    if( this.parent is Loader)
                        textInputDispatcher.removeChild(this.parent);
                    else 
                        textInputDispatcher.removeChild(this);
                }
                catch(e:Error){}
            }
        }
        
        /**
         * 
         * @param val
         * 
         */        
        public function set snap(val:String):void
        {
            keyboardSnap = val;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get snap():String
        {
            return keyboardSnap;
        }
    }
}