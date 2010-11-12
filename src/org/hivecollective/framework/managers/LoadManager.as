package org.hivecollective.framework.managers
{
	import flash.utils.Dictionary;
	
	import org.hivecollective.framework.HiveFramework;
	import org.hivecollective.framework.sequence.Sequence;
	import org.hivecollective.net.LoaderData;
	import org.hivecollective.net.LoaderSet;

	
	public final class LoadManager extends Manager
	{
		/**
		 * 
		 * @param hive
		 * 
		 */       
		public function LoadManager( hive:HiveFramework )
		{
		    super(hive);
		    init(hive);
		}

		/**
		 * 
		 * @param hive
		 * @return 
		 * 
		 */		
		protected function init(hive:HiveFramework):LoadManager
        {
            if(HiveFramework.DEBUG_MODE){trace( "LoadManager :: init" )}

            //var manager:LoadManager = new LoadManager(hive);
            hive.registerManager(this);
            
            //_____________ Register Object :: LoaderData
            function loaderDataFunc( action:*, sequence:Sequence, positionInSequence:int ):void {
                var ldr:LoaderData = action as LoaderData;
            	if( ldr && (!ldr.isLoaded && !ldr.isLoading) ){
                    ldr.load(null);
                }
            }
            hive.sequenceManager.registerAction(LoaderData, loaderDataFunc);
            
            //_____________ Register Object :: LoaderSet
            function loaderSetFunc( action:*, sequence:Sequence, positionInSequence:int ):void {
                var lds:LoaderSet = action as LoaderSet;
                lds.load();
            }
            hive.sequenceManager.registerAction(LoaderSet, loaderSetFunc);
            
            return this;
        }
		/**
		 * 
		 * @param loaderSet
		 * 
		 */        
		public function loadSet( loaderSet:LoaderSet ):void
		{
			loaderSet.startLoad();
		}
		
		/**
        *
        */
        private var LOADERSETS                :Array = new Array( );
        /**
         * 
         */        
        private var LOADERSETS_BY_NAME        :Dictionary = new Dictionary( true );
        /**
         * 
         */        
        private var LOADERS               :Array = new Array( );
        /**
         * 
         */        
        private var LOADERS_BY_NAME       :Dictionary = new Dictionary( true );
        /**
         * 
         */        
        private var LOADERS_BY_CONTENT        :Dictionary = new Dictionary( true );
        
		
				
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get loaders():Array
		{
		    return LOADERS;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get loaderSets():Array
		{
		    return LOADERSETS;
		}
		
		/**
		 * 
		 * @param loaderSet
		 * 
		 */		
		public function addLoaderSet( loaderSet:LoaderSet ):void
		{
			LOADERSETS_BY_NAME[ loaderSet.name ] = loaderSet;
			LOADERSETS.push( loaderSet );
		}
		
		/**
		 * 
		 * @param args
		 * 
		 */		
		public function add( ...args ):void
		{
			for (var i:Number = 0; i < args.length; i++) {
				if( args[i] is LoaderData ){
					LOADERS_BY_CONTENT[ args[i].contentLoaderInfo ] = args[i];
				}
				else if( args[i] ){
					LOADERS_BY_CONTENT[ args[i] ] = args[i];
				}
				LOADERS_BY_NAME[ args[i].name ] = args[i];
				LOADERS.push( args[i] );
		    }
		}
		
        /**
         * 
         * @param names
         * 
         */		
        public function removeLoaderSetByName( ...names ):void
        {
            for (var i:Number = 0; i < names.length; i++)
            removeLoaderSet( getLoadersetByName( names[i] ) );
        }
		
		/**
		 * 
		 * @param loaderSet
		 * 
		 */		
		public function removeLoaderSet( loaderSet:LoaderSet ):void
		{
		    var i:uint = LOADERSETS.indexOf(loaderSet);
            if( i != -1 ){ 
                delete LOADERSETS[i];
            }
            delete LOADERSETS_BY_NAME[ loaderSet.name ];
		}
		
		/**
		 * 
		 * @param ldr
		 * 
		 */		
		public function removeLoader( ldr:* ):void
		{
		    var i:uint = LOADERS.indexOf(ldr);
		    if( i != -1 ) delete LOADERS[i];
			delete LOADERS_BY_NAME[ ldr.name ];
			if( ldr is LoaderData ) delete LOADERS_BY_CONTENT[ ldr.contentLoaderInfo ];
			/* else if( ldr is SoundData ) delete LOADERS_BY_CONTENT[ ldr ];
			else if( ldr is URLData ) delete LOADERS_BY_CONTENT[ ldr.data ]; */
		}
		
		/**
		 * 
		 * @param names
		 * 
		 */		
		public function removeLoaderByName( ...names ):void
		{
			for (var i:Number = 0; i < names.length; i++)
		    removeLoader( getLoaderByName( names[i] ) );
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getLoaderByName( name:String ):*
		{
			return LOADERS_BY_NAME[ name ];
		}
		
		/**
		 * 
		 * @param info
		 * @return 
		 * 
		 */		
		public function getLoaderByContent( info:* ):*
		{
			return LOADERS_BY_CONTENT[ info ];
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getLoadersetByName( name:String ):*
		{
			return LOADERSETS_BY_NAME[ name ];
		}
			
		
		
		
	}
}