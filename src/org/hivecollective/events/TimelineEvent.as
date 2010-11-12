package org.hivecollective.events
{
	import flash.events.Event;

	public class TimelineEvent extends Event
	{
		/**
		 * 
		 */		
		public static const RENDER:String = 'frameLabelRender';
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}