package org.hivecollective.framework.sequence
{
	import flash.events.Event;
	
	import org.hivecollective.framework.states.StateController;
	
	public class ActionSequence extends Sequence
	{
		/**
		*
		*/
		private var _nextState:StateController;

		/**
		*
		*/
		private var _switchState:Boolean = false;

		/**
		*
		*/
		private var _nextSequence:ActionSequence;
		
		/**
		*
		* @param	name
		* @param	sequences
		*/
		public function ActionSequence( name:String=null, sequences:Array=null )
		{
			super( name, sequences );
		}
		
		/**
		*
		* @param	startIndex
		* @param	endIndex
		* @return
		*/
		public override function slice( startIndex:Number=0, endIndex:Number=16777215 ):*
		{
			var seq:ActionSequence 		= new ActionSequence( _name, _REPOSITORY.slice( startIndex, endIndex ) );
			
			seq.completeTriggerName 	= _completeEventName;
			seq.completeTriggerSource 	= _completeEventSource;

			
			seq.nextState 				= _nextState;
			seq.switchState             = _switchState;
			seq.nextSequence            = _nextSequence;
            
            seq._REPOSITORY_PARAM = _REPOSITORY_PARAM;

			return seq;
		}

		/**
		*
		* @param	value
		* @return
		*/
		public override function set complete( value:Boolean ):void
		{
			super.complete = value;
			if( _complete && !_active ){
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		/**
		*
		* @param	e
		* @return
		*/
		internal override function handleSequenceEnd( e:Event ):void
		{
			super.handleSequenceEnd( e );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		//______________________________________________________________________________ GETTERS AND SETTERS
		
		/**
		 * 
		 * @param state
		 * 
		 */			
		public function set nextState( state:StateController ):void
		{
			_nextState = state;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get nextState( ):StateController
		{
			return _nextState;
		}
        
		/**
		 * 
		 * @param contentSwitch
		 * 
		 */        
		public function set switchState( contentSwitch:Boolean ):void
		{
			_switchState = contentSwitch;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get switchState( ):Boolean
		{
			return _switchState;
		}
		/**
		 * 
		 * @param sequence
		 * 
		 */		
		public function set nextSequence( sequence:ActionSequence ):void
		{
			_nextSequence = sequence;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get nextSequence( ):ActionSequence
		{
			return _nextSequence;
		}
		
		/**
		* @private
		*/
		public override function toString():String
		{
			var returnString:String = "[ActionSequence \n \t" + _name ;
			returnString += "\t\t" + _REPOSITORY.toString( ) + " ]";
			
			return returnString;
		}
	}
}
