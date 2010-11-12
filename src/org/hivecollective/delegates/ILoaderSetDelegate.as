package org.hivecollective.delegates
{
    import flash.events.*;
    
    public interface ILoaderSetDelegate
    {
        
        function onLoaderSetBegin(e:Event):void;
        function onLoaderSetProgress(e:ProgressEvent):void;
        function onLoaderSetIOError(e:IOErrorEvent):void;
        function onLoaderSetComplete(e:Event):void;
        
    }
}