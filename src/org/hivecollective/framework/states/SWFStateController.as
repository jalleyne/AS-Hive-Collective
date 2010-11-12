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
package org.hivecollective.framework.states
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.hivecollective.framework.managers.LoadManager;
	import org.hivecollective.framework.sequence.ActionSequence;
	import org.hivecollective.framework.sequence.CloseSequence;
	import org.hivecollective.net.LoaderData;
    /**
     * 
     * @author jovan
     * 
     */	
	public class SWFStateController extends StateController implements IState
	{
		/**
		 * 
		 */		
		public var view:LoaderData;
		/**
		 * 
		 */		
		protected var content:MovieClip;
        
        /**
         * 
         * @return 
         * 
         */        
        public function create():ActionSequence
        {
            var ldm:LoadManager = hive.getManager(LoadManager) as LoadManager;
            
            if( this is ISWFState  && this['viewName'] )
                view = ldm.getLoaderByName(this['viewName']);
            else 
                view = ldm.getLoaderByName(defaultViewName);
            
            if( !view ) throw new Error("LoaderData not found for SWFState " + this);
            
            var seq:ActionSequence = new ActionSequence(null);
            seq.push(view);
            
            addEventListener( Event.RENDER, onContentReady, false, 0, true );
            
            if( !view.isLoaded ){
                
                trace(view);
                
                if( view.loaderSet )
            	view.loaderSet.forceLoad(view.name);
                else LoaderData(view).load(view.request,view.context);
                
			    view.contentLoaderInfo.addEventListener( Event.COMPLETE, onContentInit );
			    view.contentLoaderInfo.addEventListener( Event.COMPLETE, onContentComplete );
            }
            else {
                content = view.content as MovieClip;
                onContentReady(null);
            }
            
            return seq;
        }
        
        /**
         * 
         * @return 
         * 
         */        
        public function close():CloseSequence
        {
            if( view && view.contentLoaderInfo ){
                view.contentLoaderInfo.removeEventListener( Event.COMPLETE, onContentInit );
                view.contentLoaderInfo.removeEventListener( Event.COMPLETE, onContentReady );
                view.contentLoaderInfo.removeEventListener( Event.COMPLETE, onContentComplete ); 
            }
            
            var seq:CloseSequence = new CloseSequence();
            seq.push(view);
            seq.push(destroy);
            return seq;
        }
        
        /**
         * 
         * 
         */        
        public function destroy():void
        {
        	view    = null;
        	content = null;
        }
        
        /**
         * 
         * @param e
         * 
         */        
        private function onContentComplete( e:Event ):void
        {
        	var t:IEventDispatcher = e.target as IEventDispatcher;
            t.removeEventListener( Event.COMPLETE, onContentReady );
            t.removeEventListener( Event.COMPLETE, onContentComplete );
            
            dispatchEvent(new Event(Event.RENDER));
        }
        
        /**
         * 
         * @param e
         * 
         */        
        private function onContentInit( e:Event ):void
        {
            IEventDispatcher(e.target).removeEventListener( e.type, onContentInit );
            content = view.content as MovieClip;
        }
        
        /**
         * 
         * @param e
         * 
         */        
        public function onContentReady( e:Event ):void
        {
            if( this is ISWFState ){
                this['onViewReady']();
            }
        }   
        
        /**
         * 
         * @return 
         * 
         */        
        public function get defaultViewName():String
        {
            return getQualifiedClassName(this).split('::')[1];
        }
		
	}
}