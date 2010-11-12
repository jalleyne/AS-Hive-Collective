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

package org.hivecollective.framework.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.hivecollective.events.*;
	import org.hivecollective.framework.HiveFramework;
	import org.hivecollective.framework.managers.utils.LayerStack;
	import org.hivecollective.framework.sequence.ActionSequence;
	import org.hivecollective.framework.sequence.CloseSequence;
	import org.hivecollective.framework.states.ILayeredState;
	import org.hivecollective.framework.states.IState;
	import org.hivecollective.framework.states.IStateChangeDelegate;
	import org.hivecollective.framework.states.StateController;

    /**
    *
    */
	public class StateManager extends Manager
	{
		//________________________________________________ PROPERTIES

		public var currentState : StateController;
		public static var documentClass	: DisplayObjectContainer;


        private static var _stateCloseEvent : Event;
        private static var _activeSequenceDelays : Dictionary = new Dictionary( false );
		private static var _cancelList : Dictionary=new Dictionary();

		
		
		//________________________________________________ CONSTRUCTOR

		/**
		 * 
		 * @param hive
		 * 
		 */		
		public function StateManager( hive:HiveFramework )
		{
			super(hive);
		}
	

		//________________________________________________ PUBLIC METHODS
		
		private var _persistantStates:Dictionary;
		/**
		 * 
		 * @param pState
		 * @return 
		 * 
		 */		
		public function getPersistantState(pState:Class):IState
		{
		    _persistantStates = _persistantStates || new Dictionary(true);
		    return _persistantStates[pState] || (_persistantStates[pState] = new pState());
		}
		/**
		 * 
		 * @param pState
		 * @return 
		 * 
		 */		
		public function hasPersistantState(pState:Class):Boolean
		{
		    if( _persistantStates && pState )
		    return Boolean(_persistantStates[pState]);
		    else return false;
		}
		/**
		 * 
		 * @param pState
		 * @return 
		 * 
		 */		
		public function getState(pState:Object):StateController
		{
		    if( pState is Class ){
                return getPersistantState(pState as Class) as StateController;
            }
            else if( pState is IState ){
                return pState as StateController;
            }
            else throw IllegalOperationError(pState + " must be either instance of IState or a class definition that implements IState.");
            
            
		}
		
        /**
        *
        * @param	newState		Instance of application state to switch to.
        * @param	e				Event instance that caused state switch.
        * @return
        */
		public function switchState( pState:Object, e:Event=null ):void
		{
			if(HiveFramework.DEBUG_MODE){trace('CoreManager :: switchState, ',pState)}
            
            var newState:StateController = getState(pState);
            
            if( newState is ILayeredState ){
            	layerState( newState as ILayeredState );
            }
            else{
	            _stateCloseEvent = e;
	            runClose(newState);
	        }
		}
		
		/**
		 * 
		 * @param newState
		 * 
		 */		
		private function runClose(newState:StateController):void
		{
            closeLayerStack();

		    if(currentState && currentState != newState/* && 
            (currentState["constructor"] != newState["constructor"]  ) */ 
            // Jovan: this is up for debate. SWF address will handle block returning to the same state
            // so far this has been unnecessary
            ){
                if( !(newState is ILayeredState) ){
                    var closeSequence:CloseSequence = IState(currentState).close( );
                    
                    if( closeSequence ){
                        closeSequence.nextState = newState;
                        hive.sequenceManager.playSequence( closeSequence );
                    }
                    else executeStateSwitch( newState );
                }
                else executeStateSwitch( newState );
            }else if(!currentState /* ||
            (currentState && (currentState["constructor"] != newState["constructor"])) */ ) {
                executeStateSwitch( newState );
            }
		}


        /**
        *
        * @param	state
        * @return
        */
		private function configState( state:StateController ):StateController
		{
			state.hive = hive;
			state.stateManager = hive.stateManager;
            state.sequenceManager = hive.sequenceManager;

			return state;
		}
		
		/**
		 * 
		 * @param layer
		 * 
		 */		
		public function closeLayer( layer:ILayeredState ):void
		{
			_layerStack.remove(layer);
			
			var closeSequence:CloseSequence = IState(layer).close( );
            if( closeSequence )
            hive.sequenceManager.playSequence( closeSequence );
			
		}
		
		/**
		 * 
		 * 
		 */		
		public function closeLayerStack():void
		{
			if( currentState is ILayeredState ){
                var l:ILayeredState;
                
                while( l = _layerStack.getCurrentLayer() )
                closeLayer(l);
                
                currentState            = _layerStack.baseState;
                _layerStack.baseState   = null;
            }
		}
		
		/**
		 * 
		 */		
		private var _layerStack:LayerStack = new LayerStack();
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get layerStack():LayerStack
		{
		    return _layerStack;
		}
		
		/**
		 * 
		 * @param p_state
		 * @return 
		 * 
		 */		
		internal function layerState(p_state:ILayeredState):ActionSequence
		{
			if( !_layerStack.getCurrentLayer() ){
                _layerStack.baseState = currentState;
			}
			
			var layer:ILayeredState = configState( p_state as StateController ) as ILayeredState;
			_layerStack.push(layer as ILayeredState);
			
			return executeStateSwitch( layer as StateController );
		}

        /**
        *
        * @return
        */
		internal function executeStateSwitch( nextState:StateController = null ):ActionSequence
        {
            if( currentState ) 
            currentState.previousState = null; // TODO: possibly add depthlimit so users can determine how far back to remember states
            
            var ls:StateController = currentState;
            currentState = configState( nextState );

			currentState.previousState 	 = ls;
			currentState.trigger 		 = _stateCloseEvent;
            
            cleanState(ls);
            
			dispatchEvent( new Event(Event.CHANGE) );
			
			var sequence:ActionSequence = IState(currentState).create( );
			hive.sequenceManager.playSequence( sequence );

            return sequence;
        }
        
        private function cleanState(state:StateController):StateController
        {
            if( state ){
                state.stateManager = null;
                state.sequenceManager = null;
            }
            return state;
        }
        
        
        private var _delegate:IStateChangeDelegate;
        public function set delegate(p_delegate:IStateChangeDelegate):void
        {
            if(_delegate)
                removeEventListener(Event.CHANGE,_delegate.onStateChange);
            
            if(p_delegate)
                addEventListener(Event.CHANGE,p_delegate.onStateChange);
            
            _delegate = p_delegate;
        }
        
        public function get delegate():IStateChangeDelegate
        {
            return _delegate;
        }
		
	}
}