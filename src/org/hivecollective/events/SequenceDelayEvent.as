package org.hivecollective.events
{
	import org.hivecollective.framework.sequence.Sequence;
	import flash.events.Event;
	
	public class SequenceDelayEvent extends Event
	{
        /**
        *
        */
		public static var ON_COMPLETE:String = "onSequenceDelayComplete";

        /**
        *
        */
		public var sequence:Sequence;
		
        /**
        *
        * @param	type
        * @param	continueSequence
        * @param	bubbles
        * @param	cancelable
        */
		public function SequenceDelayEvent(type:String, continueSequence:Sequence, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			sequence = continueSequence;
		}

	}
}