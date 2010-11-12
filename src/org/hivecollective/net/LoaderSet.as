package org.hivecollective.net
{
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	
	import org.hivecollective.delegates.IPreloaderDelegate;
	import org.hivecollective.framework.managers.LoadManager;
	import org.hivecollective.sound.SoundData;
	
		[Event(name="complete",type="flash.events.Event")]
	public class LoaderSet extends EventDispatcher
	{
		
	    /**
	     * 
	     * @param manager
	     * @param setName
	     * @param incrementPercent
	     * @param args
	     * 
	     */	    
	    public function LoaderSet( manager:LoadManager, setName:String=null, incrementPercent:Number=40, ...args )
        {
            super();
            _name = setName || mkName(); 
            _loaderSetIncrementPercent = incrementPercent;
            _loadManager = manager;
            _loadManager.addLoaderSet(this)
            if( args.length ) add(args);
        }
	    
		/**
		 * 
		 */        
		private var LOADERS:Array = new Array();
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get loaders():Array { return LOADERS; }
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get length():uint { return LOADERS.length; }
		
		/**
		 * 
		 */		
		private var _name:String;
		/**
		 * 
		 * @return 
		 * 
		 */		 
		public function get name():String{ return _name; }
		
		/**
		 * 
		 */		
		private var _isLoading:Boolean = false;
		/**
		 * 
		 */		
		private var _isLoaded:Boolean = false;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get isLoading():Boolean { return _isLoading; }
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get isLoaded():Boolean { return _isLoaded; }
		/**
		 * 
		 */		
		private var _loaderSetIncrementPercent : Number;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get incrementPercent():Number { return _loaderSetIncrementPercent; }
		/**
		 * 
		 */		
		private var _overallPercentArray : Array = [];
		/**
		 * 
		 */		
		private var _overallPercentComplete : Number = 0;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get percent():Number { return _overallPercentComplete; }
		/**
		 * 
		 */		
		private var _loadManager:LoadManager;
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get loadManager():LoadManager{ return _loadManager; }
		
		
		
        private var _delegate:IPreloaderDelegate;
        public function set delegate(p_delegate:IPreloaderDelegate):void
        {
            if(_delegate){
                //removeEventListener(Event.OPEN, p_delegate.onPreloaderStart);
                removeEventListener(Event.COMPLETE,         _delegate.onPreloaderComplete);
                removeEventListener(ProgressEvent.PROGRESS, _delegate.onPreloaderProgress);
                removeEventListener(IOErrorEvent.IO_ERROR,  _delegate.onPreloaderError);
            }
            
            if(p_delegate){
                //addEventListener(Event.OPEN, p_delegate.onPreloaderStart);
                addEventListener(Event.COMPLETE,            p_delegate.onPreloaderComplete);
                addEventListener(ProgressEvent.PROGRESS,    p_delegate.onPreloaderProgress);
                addEventListener(IOErrorEvent.IO_ERROR,     p_delegate.onPreloaderError);
            }
            
            _delegate = p_delegate;
        }
        
        public function get delegate():IPreloaderDelegate
        {
            return _delegate;
        }
		
		
		//METHODS
		/**
		 * 
		 * @param ldr
		 * @return 
		 * 
		 */		
		public function getLoaderPosition( ldr:* ):int
		{
		    return LOADERS.indexOf(ldr.name);
		}
        /**
         * 
         * @param ldrs
         * @return 
         * 
         */		
        public function add( ...ldrs ):*
        {
            for each( var ldr:* in ldrs ){
                if( ldr is Array && (ldr as Array).length ) 
                add( ldr );
                
                if( ldr.hasOwnProperty("loaderSet") )
                ldr["loaderSet"] = this;
                
                if( ldr is String && validateAlreadyAdded(ldr) ) {
                    LOADERS.push(ldr);
                }
                else if( ldr && validateAlreadyAdded(ldr.name) ) 
                {
                    loadManager.add(ldr);
                    LOADERS.push(ldr.name);
                }
                
            }
            return ldr;
        }
        /**
         * 
         * @param ldrName
         * @return 
         * 
         */
        private function validateAlreadyAdded( ldrName:String ):Boolean
        {
        	var r:Boolean = Boolean(LOADERS.indexOf(ldrName)==-1);
        	if( !r ) 
        	throw new IllegalOperationError(ldrName+" is already added to [LoaderSet["+name+"]]");
        	
        	return r;
        }
		/**
		 * 
		 * 
		 */        
		public function load():void
		{
			quedLoader = LOADERS[0];

			for( var i:Number = 0; i<LOADERS.length; i++) {
				_overallPercentArray[i] = 0;
			}
			_isLoading = true;

			loadNextInSet();
		}
		
		/**
		 *
		 * @deprecated : use load() instead.
		 * @see : LoaderSet.load(). 
		 * 
		 */		
		public function startLoad():void
		{
		    load();
		}
		/**
		 * 
		 */		
		public var quedLoader:String = "";
		/**
		 * 
		 * 
		 */		
		private function loadNextInSet():void
		{
			var elgibleLoaders:Array = LOADERS.filter( filterEligibleLoaders );
			
			if( elgibleLoaders.length ){
				var quedIndex:Number 	= elgibleLoaders.indexOf( quedLoader );
				quedIndex 				= quedIndex == -1 ? 0 : quedIndex; 
				var nextIndex:Number = (quedIndex + 1 == elgibleLoaders.length ) ? 0 : quedIndex + 1;
				
				if( elgibleLoaders.length <= 1 )
				{
					doLoad( loadManager.getLoaderByName(elgibleLoaders[ 0 ]) );
					quedLoader = null;
				}
				else {
					doLoad( loadManager.getLoaderByName(elgibleLoaders[ quedIndex ]) );
					quedLoader = elgibleLoaders[ nextIndex ];
				}
			}
			else{
				checkLoaderSetComplete();
			}
		}
		/**
		 * 
		 * @param item
		 * @param index
		 * @param array
		 * @return 
		 * 
		 */		
		private function filterEligibleLoaders( item:*, index:int, array:Array):Boolean
		{
			var quedIndex:Number = LOADERS.indexOf( item );
			var quedLoader:* = loadManager.getLoaderByName(LOADERS[quedIndex]);
			return (!quedLoader.isLoading && !quedLoader.isLoaded);
		}
		/**
		 * 
		 * @param loaderName
		 * 
		 */		
		public function forceLoad( loaderName:String ):void
		{
			quedLoader = loaderName;
			loadNextInSet();
		}
		
		/**
		 * 
		 * @param ldr
		 * 
		 */		
		private function doLoad( ldr:* ):void
		{
			if( ldr is LoaderData ){
				if( !ldr.isLoaded && !ldr.isLoading ){
					try {
						ldr.load(null);
					} catch( e:Error ){
						trace("LoaderSet :: load() : "+e);
					}
					
					configureListeners( ldr.contentLoaderInfo );
					ldr.isLoading = true;
				}
			}
			else if ( ldr['load'] is Function /* || ldr is URLData */ ){
				if( !ldr.isLoading && !ldr.isLoaded  ){
					ldr.load( ldr.URL );
					configureListeners( ldr );
					ldr.isLoading = true;
				}
			}
			
			if( ldr && ldr.hasOwnProperty("loaderset") )
			ldr.loaderset = this;
		}
		
		
		/**
		 * 
		 * @param dispatcher
		 * 
		 */		
		private function configureListeners(dispatcher:IEventDispatcher):void 
		{
            dispatcher.addEventListener(Event.OPEN, openHandler, false, 0, true);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, handleError, false, 0, true);
            dispatcher.addEventListener(Event.COMPLETE, handleComplete);
        }
        /**
         * 
         * @param dispatcher
         * 
         */        
        private function removeListeners(dispatcher:IEventDispatcher):void 
		{
            dispatcher.removeEventListener(Event.OPEN, openHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            dispatcher.removeEventListener(Event.COMPLETE, handleComplete);
        }
		
		
		/**
		 * 
		 * @param percentOfLoaderData
		 * @param positionInLoadSet
		 * 
		 */		
		private function changeOverallPercent( percentOfLoaderData:Number, positionInLoadSet:int ):void
		{
			_overallPercentArray[positionInLoadSet] = Math.round( percentOfLoaderData );
			var num : Number = 0;
			for (var i:Number = 0; i < LOADERS.length; i++) {
				num += _overallPercentArray[i];
		    }
			
			_overallPercentComplete = num / LOADERS.length;

			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, _overallPercentComplete, 100 ) );
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */		
		public function setPause( name:String ):void
		{
			_isLoading = false;
			var ldr:Object;
			for each( var element:String in LOADERS ){
			    ldr = _loadManager.getLoaderByName( element );
				if (element != name && ldr.isLoading ){
					try {
						ldr.close();
						removeListeners( IEventDispatcher(ldr) );
					} catch( e:Error ){
					}
				}
			}
		}
		
		/**
		 * 
		 * 
		 */		
		public function setResume():void
		{
			_isLoading = true;
			LOADERS.forEach( resume );
		}
		
		/**
		 * 
		 * @param element
		 * @param index
		 * @param arr
		 * 
		 */		
		private function pause( element:*, index:Number, arr:Array ):void
		{
		    var ldr:Object = _loadManager.getLoaderByName( element );
			if( ldr.isLoading ){
				try {
					removeListeners( IEventDispatcher(ldr) );
					try {
						ldr.close();
					} catch( e:Error ){
						trace(e);
					}
				} catch( e:Error ){
					trace(e);
				}
			}
			
		}
		/**
		 * 
		 * @param element
		 * @param index
		 * @param arr
		 * 
		 */		
		private function resume( element:*, index:Number, arr:Array ):void
		{
		    var ldr:Object = _loadManager.getLoaderByName( element );
			if( ldr.isLoading )
			ldr.load( ldr.URL );
		}
		
		

		
		
		
		//EVENTS
		
        /**
         * 
         * @param e
         * 
         */        
        private function openHandler(e:Event):void {
			_loadManager.getLoaderByContent(e.currentTarget).isLoading = true;
        }
		/**
		 * 
		 * @param e
		 * 
		 */        
		private function handleProgress( e:ProgressEvent ):void
		{
			var percent : Number = Math.round( (e.bytesLoaded / e.bytesTotal) * 100 );
			var ldr:Object = _loadManager.getLoaderByContent(e.currentTarget);
			
            changeOverallPercent( Math.min(percent,100), getLoaderPosition( ldr ) );
				
			if( percent >= _loaderSetIncrementPercent ){
				loadNextInSet();
			}
		}
		/**
		 * 
		 * @param element
		 * @param index
		 * @param arr
		 * @return 
		 * 
		 */		
		private function checkHandlers( element:*, index:Number, arr:Array):Boolean
		{
			return loadManager.getLoaderByName(element).isLoaded;
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handleComplete( e:Event ):void
		{
			trace("loadManager :: Complete : " + _loadManager.getLoaderByContent(e.currentTarget).name);

			var ldr:Object = _loadManager.getLoaderByContent(e.currentTarget);
			ldr.isLoading = false;
			ldr.isLoaded = true;

			if( ldr is LoaderData )	{
                removeListeners( ldr.contentLoaderInfo );
            }
			else if ( ldr is SoundData/*  || ldr is URLData */ ){
				removeListeners(ldr as IEventDispatcher);
			}
							
			checkLoaderSetComplete();
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function checkLoaderSetComplete( ):Boolean
		{
			if( LOADERS.filter( checkHandlers ).length == LOADERS.length ){
				_isLoading = false;
				_isLoaded = true;
			    dispatchEvent( new Event( Event.COMPLETE ) );
				return true;
			}else{
	       		return false;
            }
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handleError( e:IOErrorEvent ):void
		{
			trace("loadManager :: handleError : " + e );
            //TODO: add stopLoadOnError property 
   			dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR, false, false, e.text ) );
			loadNextInSet();
		}
		
        
		
        
        /**
         * 
         */        
        private static var _ldrCount:int=0;
        /**
         * 
         * @return 
         * 
         */        
        private static function mkName():String
        {
            return 'loaderset'+(++_ldrCount);
        }
		
	}
	
}