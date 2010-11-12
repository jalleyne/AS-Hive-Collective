package org.hivecollective.net
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.profiler.showRedrawRegions;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class LoaderData extends Loader
	{
        public var autoLoad:Boolean = false;
        
        protected var _autoLoadOnAdded:Boolean = false;
        
		/**
		 * 
		 */	    
		public var incrementPassed:Boolean;
		/**
		 * 
		 */		
		public var loaderSet:LoaderSet;
		/**
		 * 
		 */		
		public var isLoading : Boolean = false;
		/**
		 * 
		 */		
		public var isLoaded:Boolean = false;
		/**
		 * 
		 */		
		public var request:URLRequest;
		/**
		 * 
		 */		
		public var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
		
		/**
		 * 
		 * @param p_request
		 * @param p_name
		 * @param p_context
		 * 
		 */		
		public function LoaderData( p_request:URLRequest=null, p_name:String=null, p_context:LoaderContext=null, 
                                    shouldAutoLoad:Boolean=false, shouldAutoLoadOnAdded:Boolean=false, onLoadHandler:Function=null )
		{
		    super();
            
		    super.name  = p_name || super.name;
		    context     = p_context || context;
            request     = p_request;
            
            if( shouldAutoLoad && 
                request ){
                load(null);
            }
            
            if( onLoadHandler != null )
            {
                contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadHandler,false,0,true);
            }
            
            if( shouldAutoLoadOnAdded )
                autoLoadOnAdded = true;
		}
        
        /**
         * 
         * @param val
         * 
         */        
        public function set autoLoadOnAdded(val:Boolean):void
        {
            if( val ){
                removeEventListener( Event.ADDED_TO_STAGE, onAutoLoad );
                addEventListener( Event.ADDED_TO_STAGE, onAutoLoad, false, 0, true );
            }
            else 
            {
                removeEventListener( Event.ADDED_TO_STAGE, onAutoLoad );
            }
            
            _autoLoadOnAdded = val;
        }
        
        /**
         * 
         * @return 
         * 
         */        
        public function get autoLoadOnAdded():Boolean
        {
            return _autoLoadOnAdded;
        }
        
        /**
         * 
         * @param e
         * 
         */        
        protected function onAutoLoad(e:Event):void
        {
            if(!isLoaded)
            load(null);
        }
        
        public function get movieClipContent():MovieClip
        {
            return content as MovieClip;
        }
		
		/**
		 * 
		 * @param p_request
		 * @param p_context
		 * 
		 */		
		override public function load(p_request:URLRequest, p_context:LoaderContext=null):void
		{
		    context = p_context || context; 
		    request = p_request || request;
		    super.load(request, context);
            
            contentLoaderInfo.addEventListener( Event.COMPLETE, makeIsLoaded );
		}
        
        private function makeIsLoaded(e:Event):void
        {
            contentLoaderInfo.removeEventListener( Event.COMPLETE, makeIsLoaded );
            isLoaded = true;
        }
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		override public function set name(value:String):void
		{
		    throw IllegalOperationError('LoaderData property [name] is read-only.');
		}
		
	}
}