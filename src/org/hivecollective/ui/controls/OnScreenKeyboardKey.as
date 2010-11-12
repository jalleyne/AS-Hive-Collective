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
 * @author	Jovan Alleyne, Peter Nitsch, Brandon Flowers
 * @version	1.0a
 * @since	Flash 9
 */
package org.hivecollective.ui.controls
{
    
    import com.greensock.TweenLite;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import org.hivecollective.events.OnScreenKeyboardEvent;
    /**
     * 
     * @author jovan
     * 
     */    
    public class OnScreenKeyboardKey extends BasicButton
    {
        public function OnScreenKeyboardKey()
        {
            super();
        }
        
        override protected function init():void
        {
            super.init();
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false,0,true);
            addEventListener(MouseEvent.MOUSE_UP,   onMouseUp,   false,0,true);
        }
        
        protected function onMouseDown(e:MouseEvent):void
        {
            TweenLite.to(this,0.25,
                {
                    scaleX : 1.1,
                    scaleY : 1.1
                }
            );
        }
        
        protected function onMouseUp(e:MouseEvent):void
        {
            TweenLite.to(this,0.25,
                {
                    scaleX : 1,
                    scaleY : 1
                }
            );
        }
        
        override protected function onClick(e:MouseEvent):void
        {
            dispatchEvent(
                new OnScreenKeyboardEvent( OnScreenKeyboardEvent.KEYBOARD_KEY_PRESS, true )
            );
        }
    }
}