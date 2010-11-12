package org.hivecollective.framework.states
{
	import flash.events.Event;
	
	import org.hivecollective.framework.managers.LayoutManager;
	
	public interface ISWFState
	{
	    /**
	     * 
	     * @param e
	     * 
	     */	   
	    function onViewReady():void;	
       
        /**
         * 
         * @param layout
         * 
         */        
        function viewWillBeAdded(layout:LayoutManager):void;
        /**
         * 
         * @param layout
         * 
         */        
        function viewWasAdded(layout:LayoutManager):void;
        
        /**
         * 
         * @param layout
         * 
         */        
        function viewWillBeRemoved(layout:LayoutManager):void;
        
        /**
         * 
         * @param layout
         * 
         */        
        function viewWasRemoved(layout:LayoutManager):void;
        
        /**
         * 
         * @return 
         * 
         */        
        function get viewName():String;
	}
}