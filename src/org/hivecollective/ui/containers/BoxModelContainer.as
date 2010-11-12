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
package org.hivecollective.ui.containers
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    /**
     * 
     * @author jovan
     * 
     */    
    public class BoxModelContainer extends Sprite
    {
        /**
         * 
         */        
        public var overflow:String = "visible";
        /**
         * 
         */        
        public var padding:Number=15;
        /**
         * 
         */        
        private var _fWidth:Number = 0;
        /**
         * 
         * 
         */        
        public function BoxModelContainer()
        {
            super();
            init();
        }
        /**
         * 
         * 
         */        
        private function init():void
        {
            addEventListener(Event.ADDED,   onDisplayListChange, false, 0, true);
            addEventListener(Event.REMOVED, onDisplayListChange, false, 0, true);
        }
        /**
         * 
         * @param num
         * 
         */        
        public function set flowWidth(num:Number):void
        {
            _fWidth = num;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get flowWidth():Number
        {
            return _fWidth;
        }
        /**
         * 
         * @param child
         * @return 
         * 
         */        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            super.addChild(child);
            return child;
        }
        /**
         * 
         * @param child
         * @param index
         * @return 
         * 
         */        
        override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
        {
            super.addChildAt(child,index);
            return child;
        }
        /**
         * 
         * @param e
         * 
         */        
        private function onDisplayListChange(e:Event):void
        {
            if( e.target as DisplayObject && contains(DisplayObject(e.target)) )
                updateLayout();
        }
        /**
         * 
         * 
         */        
        private function updateLayout():void
        {
            var child:DisplayObject,
            runW:Number = padding,
                runH:Number = padding;
            
            var heightsPerRow:Array = [],
                r:uint = 0;
            
            for( var i:uint=0; i<numChildren; ++i )
            {
                child = getChildAt(i);
                
                if( runW >= flowWidth && flowWidth > 0 )
                {
                    child.x = padding;
                    child.y = heightsPerRow[r];
                    
                    runH = child.y;
                    
                    ++r;
                }
                else {
                    child.x = runW;
                    child.y = runH;
                } 
                
                runW = child.x + child.width + padding;
                
                heightsPerRow[r] = Math.max( 
                    uint(heightsPerRow[r]), 
                    child.y + child.height + padding
                );
                
            }
        }
        
    }
}