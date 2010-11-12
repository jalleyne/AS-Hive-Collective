package org.hivecollective.delegates
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;

    public interface IPreloaderDelegate
    {
        /**
         * 
         * @param e
         * 
         */        
        function onPreloaderComplete(e:Event):void;
        /**
         * 
         * @param e
         * 
         */        
        function onPreloaderError(e:IOErrorEvent):void;
        /**
         * 
         * @param e
         * 
         */        
        function onPreloaderProgress(e:ProgressEvent):void;
    }
}