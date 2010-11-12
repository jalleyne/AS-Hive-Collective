package org.hivecollective.net
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;

    public interface IURLLoaderDelegate
    {
        /**
         * 
         * @param e
         * 
         */        
        function onURLRequestOpen(e:Event):void;
        /**
         * 
         * @param e
         * 
         */        
        function onURLRequestError(e:IOErrorEvent):void;
        /**
         * 
         * @param e
         * 
         */        
        function onURLRequestProgress(e:ProgressEvent):void;
        /**
         * 
         * @param e
         * 
         */        
        function onURLRequestComplete(e:Event):void;
    }
}