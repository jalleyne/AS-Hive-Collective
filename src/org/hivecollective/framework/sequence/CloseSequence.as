/**
* ...
* @author Jovan Alleyne
* @version 0.1
*/

package org.hivecollective.framework.sequence
{
	import flash.events.Event;
	
	import org.hivecollective.events.SequenceEvent;
	import org.hivecollective.framework.states.StateController;

	public class CloseSequence extends Sequence
	{

        /**
        *
        * @param	name
        * @param	sequences
        */
		public function CloseSequence( name:String=null, sequences:Array=null )
		{
			super( name, sequences );
        }

        /**
        * @private
        * @param	value
        * @return
        */
        public override function set complete( value:Boolean ):void
        {
            super.complete = value;

            if( _complete && !_active ){
                var event:SequenceEvent = new SequenceEvent( SequenceEvent.ON_COMPLETE );
                dispatchEvent( event );
            }
        }
		
        /**
        * @private
        * @param	e
        * @return
        */
		internal override function handleSequenceEnd( e:Event ):void
		{
            super.handleSequenceEnd( e );

			var event:SequenceEvent = new SequenceEvent( SequenceEvent.ON_COMPLETE, null, false, null, e );
			dispatchEvent( event );
		}
		/**
		 * 
		 * @param startIndex
		 * @param endIndex
		 * @return 
		 * 
		 */		
		public override function slice( startIndex:Number=0, endIndex:Number=16777215 ):*
		{
			var seq:CloseSequence 		= new CloseSequence( _name, _REPOSITORY.slice( startIndex, endIndex ) );
			seq.completeTriggerName 	= _completeEventName;
			seq.completeTriggerSource 	= _completeEventSource;
            seq.nextState               = nextState;
            
            seq._REPOSITORY_PARAM = _REPOSITORY_PARAM;
            
			if( _active ) {
				if( seq.length ) kill( );
			}

			return seq;
		}
		/**
		 * 
		 */		
		public var nextState:StateController;
		
		/**
		* @private
		*/
		public override function toString():String
		{
			var returnString:String = "[CloseSequence \n \t" + _name ;
			returnString += "\t\t" + _REPOSITORY.toString( ) + " ]";
			
			return returnString;
		}
	}
	
}
