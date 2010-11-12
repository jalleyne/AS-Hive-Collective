package org.hivecollective.framework.states
{
	import org.hivecollective.framework.sequence.CloseSequence;
	
	public interface ILayeredState
	{
        /**
         * 
         * @return 
         * 
         */	    
        function get baseState():Class;
		
	}
}