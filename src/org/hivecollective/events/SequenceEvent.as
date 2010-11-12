package org.hivecollective.events
{
	import flash.events.Event;
	
	import org.hivecollective.framework.sequence.ActionSequence;
	import org.hivecollective.framework.states.StateController;

	public class SequenceEvent extends Event
	{
        /**
        *
        */
		public static const ON_CANCEL:String = "onActionSequenceCancel";
		
        /**
        *
        */
		public static const ON_COMPLETE:String = "onActionSequenceComplete";

        /**
        *
        */
		public var nextSequence:ActionSequence;

        /**
        *
        */
		public var content:StateController;

        /**
        *
        */
		public var switchState:Boolean;

        /**
        *
        */
		public var trigger:Event;
		
        /**
        *
        */
		public static const ON_CHANGE:String = "onSequenceChange";

        /**
        *
        */
		//public var currentMotion:Motion;

        /**
        *
        */
		//public var previousMotion:Motion;
		
        /**
        *
        * @param	type
        * @param	nextSeq
        * @param	contentSwitch
        * @param	nextState
        * @param	triggerEvent
        * @param	bubbles
        * @param	cancelable
        */
		public function SequenceEvent(type:String, nextSeq:ActionSequence=null, contentSwitch:Boolean=false, nextState:StateController=null, triggerEvent:Event=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			nextSequence = nextSeq;
			content = nextState;
			switchState = contentSwitch;
			trigger = triggerEvent;
		}
	}
}