package org.hivecollective.framework.sequence
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import org.hivecollective.framework.sequence.Sequence;
	import org.hivecollective.events.SequenceDelayEvent;
	import flash.events.EventDispatcher;

	public class SequenceDelay extends EventDispatcher
	{
        /**
        *
        */
		private var __sequence:Sequence;

        /**
        *
        */
		private var __timer:Timer;
		
        /**
        *
        * @param	delay
        */
		public function SequenceDelay( delay:Number )
		{
			__timer = new Timer( delay, 1 );
			__timer.addEventListener( TimerEvent.TIMER_COMPLETE, onDelayComplete, false, 0, true );
		}
		
        /**
        *
        * @return
        */
        public function stop( ):void
        {
            return __timer.stop();
        }

        /**
        *
        * @param	onCompleteHandler
        * @param	sequence
        * @return
        */
		public function start( onCompleteHandler:Function, sequence:Sequence ):void
		{
			addEventListener( SequenceDelayEvent.ON_COMPLETE, onCompleteHandler, false, 0, true );
			__sequence = sequence;
			__timer.start( );
		}
		
        /**
        *
        * @param	e
        * @return
        */
		private function onDelayComplete( e:TimerEvent ):void
		{
			var event:SequenceDelayEvent = new SequenceDelayEvent( SequenceDelayEvent.ON_COMPLETE, __sequence );
			dispatchEvent( event );
		}
	}
}