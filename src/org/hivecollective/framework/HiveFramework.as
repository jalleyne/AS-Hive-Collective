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

package org.hivecollective.framework
{
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import org.hivecollective.framework.context.HiveCoreContext;
    import org.hivecollective.framework.managers.Manager;
    import org.hivecollective.framework.managers.SequenceManager;
    import org.hivecollective.framework.managers.StateManager;
    import org.hivecollective.framework.states.StateController;
    
    /**
     * The Hive class is the application document class and contains global settings.
     */
    public class HiveFramework extends EventDispatcher
    { 
        
        public static const NAME:String = 'Hive State Framework';
        public static const VERSION:String = '1.0a';
        public static var DEBUG_MODE:Boolean = true;
        
        
        //________________________________________________ PROPERTIES
        
        public var canvas : DisplayObjectContainer;
        public var stateManager : StateManager;
        public var sequenceManager : SequenceManager;
        
        
        public function getParameter( val:String ):Object
        {
            return canvas.loaderInfo.parameters[val];
        }
        
        
        //________________________________________________ CONSTRUCTOR
        
        /**
         * Creates an instance of the Hive framework.
         */
        public function HiveFramework( canvas:DisplayObjectContainer )
        {
            if(HiveFramework.DEBUG_MODE){trace(NAME +" :: "+ VERSION)}
            init(canvas);
        }
        
        private function init(canvas:DisplayObjectContainer):void 
        {
            this.canvas = canvas;
            
            stateManager = new StateManager(this);
            sequenceManager = new SequenceManager(this);
        }
        
        
        //________________________________________________ INIT
        public function run(state:Object):void 
        {
            stateManager.switchState(state);
        }
        
        //________________________________________________ METHODS
        
        protected var _context:HiveCoreContext;
        public function getContext():HiveCoreContext
        {
            return _context;
        }
        
        public function setContext(context:HiveCoreContext):HiveCoreContext
        {
            _context = context;
            _context.configure(this);
            
            return _context;
        }
        
        //________________________________________________ PLUGIN MANAGERS
        
        private var _managerLib:Dictionary = new Dictionary(true);
        
        public function registerManager( manager:Manager ):void 
        {
            _managerLib[getManagerKey(manager)] = manager;
        }
        
        public function getManager( type:Object ):Manager 
        {
            if( type is String )
                return _managerLib[type];
            else return _managerLib[getManagerKey(type)];
        }
        
        private function getManagerKey( manager:Object ):String
        {
            return getQualifiedClassName(manager);
        }
        
        
    }
}
