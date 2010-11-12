
/**
*
* Interface describing methods for a State object.
*
* @author	Jovan Alleyne, Peter Nitsch
* @version	1.0
* @since	Flash 9
*
*/

package org.hivecollective.framework.states
{
	import org.hivecollective.framework.sequence.ActionSequence;
	import org.hivecollective.framework.sequence.CloseSequence;
	
	public interface IState
	{
		/**
		* Method that runs when a state is instanciated. This is designed
        * to be the entry point to a state. An ActionSequnce object
        * should be returned describing the animation this state describes.
		*
		* @see		close
        * @see      ActionSequence
        */
		function create( )	:ActionSequence;
		
		/**
		* This method is called when a state has been changed. A CloseSequence
        * object is returned to animate out and onscreen elements that do
        * not need to be transfered to the next state.
		*
        * @see		create
		* @see		CloseSequence
		*/
		function close( )	:CloseSequence;
	}
}