package org.hivecollective.framework.states
{
    import flash.events.Event;

    public interface IStateChangeDelegate
    {
        function onStateChange(e:Event):void;
    }
}