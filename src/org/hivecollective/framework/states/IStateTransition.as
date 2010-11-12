package org.hivecollective.framework.states
{
    import flash.display.DisplayObject;
    
    import org.hivecollective.framework.sequence.ActionSequence;
    import org.hivecollective.framework.sequence.CloseSequence;
    
    public interface IStateTransition
    {
        /**
         * 
         * @param action
         * @param sequence
         * @param positionInSequence
         * 
         */        
        function openTransition( action:DisplayObject, sequence:ActionSequence, positionInSequence:int ):void;
        
        /**
         * 
         * @param action
         * @param sequence
         * @param positionInSequence
         * 
         */        
        function closeTransition( action:DisplayObject, sequence:CloseSequence, positionInSequence:int ):void;
        
    }
}