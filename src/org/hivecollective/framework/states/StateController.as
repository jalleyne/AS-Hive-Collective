
/**
*
* Object representing the visual state of an experience.
* This object implements two methods to standardize the entry and exit
* points of a state. All the properties of a state are set by Experience
* Manager and become available in the create method.
*
* @author	Jovan Alleyne, Peter Nitsch
* @version	1.0a
* @since	Flash 9
*
*/

package org.hivecollective.framework.states
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.hivecollective.framework.HiveFramework;
	import org.hivecollective.framework.context.HiveCoreContext;
	import org.hivecollective.framework.managers.SequenceManager;
	import org.hivecollective.framework.managers.StateManager;
		
	public class StateController extends EventDispatcher
	{
        /**
		* Reference to the previous display state of the experience.
		*/
		public var previousState : StateController = null;
        
        /**
		* Reference to the event which caused the state change.
		*/
		public var trigger : Event = null;
		
		/**
        * Reference to HIVE framework instance.
        */
		public var hive : HiveFramework;
		
		/**
		 * Object defining commonly used properties accessibly from a State. 
		 */		
		public function get context():HiveCoreContext
        {
            return hive.getContext();
        }
        
        /**
        * Reference to StateManager.
        */
        public var stateManager : StateManager;
        
        /**
        * Reference to SequenceManager.
        */
        public var sequenceManager : SequenceManager;
	}
}