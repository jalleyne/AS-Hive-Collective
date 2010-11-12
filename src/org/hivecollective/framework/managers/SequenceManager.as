package org.hivecollective.framework.managers
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.hivecollective.events.*;
	import org.hivecollective.framework.HiveFramework;
	import org.hivecollective.framework.sequence.ActionSequence;
	import org.hivecollective.framework.sequence.CloseSequence;
	import org.hivecollective.framework.sequence.Sequence;
	import org.hivecollective.framework.sequence.SequenceDelay;
	import org.hivecollective.framework.sequence.SequenceFunction;

	public class SequenceManager extends Manager
	{

		/**
		 * 
		 */        
		private var _SEQUENCES:Dictionary = new Dictionary( );
		/**
		 * 
		 */		
		private var _SEQUENCES_BY_NAME:Dictionary = new Dictionary( );
		/**
		 * 
		 */		
		private var _CURRENT_SEQUENCE:Sequence;
		/**
		 * 
		 */		
		private var _LAST_SEQUENCE:Sequence;
		
		
       
		
		//_________________________________________________________________________________________________ PRIVATE PROPERTIES
        /**
         * 
         */        
        private static var _activeSequenceDelays   : Dictionary = new Dictionary( false );
		/**
		 * 
		 */        
		private static var _cancelList             : Dictionary=new Dictionary();

		/**
		 * 
		 */		
		protected var actionLib : Dictionary = new Dictionary(false);
		/**
		 * 
		 */		
		protected var tweenableActionLib : Dictionary = new Dictionary(false);
		
		
		
		
		//_________________________________________________________________________________________________ PUBLIC METHODS

		
        /**
        *
        * @param	target
        */
		public function SequenceManager( hive:HiveFramework )
		{
			super(hive);
			
		}

		
		 /**
        *
        * @param	sequence
        * @return
        */
		public function add( sequence:Sequence ):Sequence
		{
            if( _SEQUENCES[ _SEQUENCES_BY_NAME[ sequence.name ] ] )
            delete _SEQUENCES[ _SEQUENCES_BY_NAME[ sequence.name ] ];

			_SEQUENCES_BY_NAME[ sequence.name ] = sequence;
			_SEQUENCES[ sequence ] = sequence.name;
			
			return sequence;
		}
		
        /**
        *
        * @param	sequence
        * @return
        */
		public function remove( sequence:Sequence ):Sequence
		{
		    _SEQUENCES[ sequence ] = null;
			delete _SEQUENCES[ sequence ];
			delete _SEQUENCES_BY_NAME[ sequence.name ];
			return sequence;
		}
		
        /**
        *
        * @param	name
        * @return
        */
		public function removeByName( name:String ):Sequence
		{
			return remove( getSequenceByName( name ) );
		}
		
        /**
        *
        * @param	name
        * @return
        */
		public function getSequenceByName( name:String ):Sequence
		{
			return _SEQUENCES_BY_NAME[ name ];
		}
		
        /**
        *
        * @param	sequence
        */
		public function set currentSequence( sequence:Sequence ):void
		{
			_LAST_SEQUENCE = _CURRENT_SEQUENCE;
			_CURRENT_SEQUENCE = sequence;
		}

        /**
        *
        * @return
        */
		public function get currentSequence( ):Sequence
		{
			return _CURRENT_SEQUENCE;
		}
		
        /**
        *
        * @param	sequence
        */
		public function set lastSequence( sequence:Sequence ):void
		{
			_LAST_SEQUENCE = sequence;
		}
		public function get lastSequence( ):Sequence
		{
			return _LAST_SEQUENCE;
		}
		
				
		/**
        *
        * @param	definition		Registers the class definition to the action library.
        * @param	callback		Registers the callback function with the class definition: callback( action:*, sequence:Sequence, positionInSequence:int ).
		* @param	tweenable		Use Tweener if true.
        */
		
		public function registerAction( definition:Class, callback:Function, tweenable:Boolean=false ):void
		{
			if ( tweenable )
				tweenableActionLib[ definition ] = callback;
			else
				actionLib[ definition ] = callback;
		}
		
		/**
        *
        * @param	definition		Unregisters the class definition from the action library.
		* @param	tweenable		Unregisters tweenable action if true.
        */
		
		public function unregisterAction( definition:Class, tweenable:Boolean=false ):void
		{
			if ( tweenable )
				delete tweenableActionLib[ definition ];
			else
				delete actionLib[ definition ];
		}
		
        /**
        *
        * @param	sequence		Instance of sequence to play.
        * @return
        */
		public function playSequence( sequence:Sequence ):void
		{
			if(sequence){
				if(HiveFramework.DEBUG_MODE){
				    trace(hive.stateManager.currentState,' playSequence : ', sequence.name);
				}
				
				if( !sequence.active ){
	                currentSequence = add( sequence );
					sequence.activate();
				}
				
				for ( var i : Number = 0; i < sequence.length; i++ ) {
					var action			:* = sequence.index(i);
					var scope			:*;
					var actionPlayed	:Boolean = false;

					for ( var definition:* in actionLib ) {
						if ( action is definition ) {
							actionLib[ definition ]( action, sequence, i );
							actionPlayed = true;
						}
					}
					
					if( action is SequenceDelay )
	                {
	                    if( !_activeSequenceDelays[ sequence.name ] )
	                    _activeSequenceDelays[ sequence.name ] =  new Dictionary( );
	
	                    _activeSequenceDelays[ sequence.name ][ action ] = i;
	
						action.start( onExecuteResumed, sequence.slice( ++i ) );
						return;
					} 
					else if( action is SequenceFunction )
	                {
	                    var sequenceFunction:SequenceFunction = action;
	                    sequenceFunction.method.apply( sequenceFunction.scope, sequenceFunction.argumentsList );
	                }
					else if ( action as Object && action.hasOwnProperty("scope") )
					{
						for ( var conditionalClass:* in tweenableActionLib ) {
							if ( action.scope as conditionalClass != null ) {
								tweenableActionLib[ conditionalClass ]( action, sequence, i );
							}
						}
					}
					else if( action is Function ){
					    action.apply( action, sequence.getParams(action) );
					}
					else
					{
						if ( !actionPlayed )
						{
							if(HiveFramework.DEBUG_MODE){trace("StateManager :: playSequence : Action definition not registered, " + action)}
						}
					}
				}
	
	            if( sequence is CloseSequence && CloseSequence(sequence).nextState ) 
	            hive.stateManager.executeStateSwitch( CloseSequence(sequence).nextState );
	            
	            sequence.complete = true;
                remove(sequence);
	                
                if( sequence is ActionSequence && ActionSequence(sequence).nextState )
                hive.stateManager.switchState(ActionSequence(sequence).nextState);
				
			}else {
				if(HiveFramework.DEBUG_MODE){trace("StateManager :: playSequence : Sequence is null. ")}
			}
		}
		
		/**
        *
        * @param	name
        * @return
        */
		public function cancelSequence( name:String ):Boolean
		{
            //trace('StateManager :: cancelSequence : '+name);

			if( name is String ){
				_cancelList[ name ] = true;
                executeCancelSequence( name );
                remove(getSequenceByName(name)); // TODO: test cancel sequence
				return true;
			}
			return false;
		}
		
		//_________________________________________________________________________________________________ PRIVATE METHODS


        /**
        *
        * @param	name
        * @return
        */
        private function executeCancelSequence( name:String ):Boolean
        {
           //trace('StateManager :: executeCancelSequence : '+name);

            var sequence:Sequence;

            if( _cancelList[ name ] &&
                ( sequence = getSequenceByName( name )) != null ){

                sequence.kill( );

                for( var delay:* in _activeSequenceDelays[ name ] ){
                    delay.stop( );
                    delete _activeSequenceDelays[ name ][ delay ];
                }

                delete _cancelList[ name ];

                sequence.dispatchEvent( new Event(Event.CANCEL) );

                return true;
            }
            else return false;
        }
		
        /**
        *
        * @param	e
        * @return
        */
		private function onExecuteResumed( e:SequenceDelayEvent ):void
		{
            delete _activeSequenceDelays[ e.sequence.name ];

            if( !e.sequence.length ) 
            {
                remove(e.sequence);
                return;
            }

			if( _cancelList[ e.sequence.name ] ) {
                executeCancelSequence( e.sequence.name );
				return;
			}
			else playSequence( e.sequence );
		}
		
	}
}