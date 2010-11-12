package org.hivecollective.parsers
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    public class Settings extends EventDispatcher
    {
        /**
         * 
         * @param req
         * 
         */        
        public function Settings(req:URLRequest=null)
        {
            if( req )
            loadSettings(req);
        }
        
        /**
         * 
         */        
        private var _ldr:URLLoader;
        /**
         * 
         * @return 
         * 
         */        
        public function get loader():URLLoader
        {
            return _ldr;
        }
        /**
         * 
         * @param location
         * 
         */        
        public function loadSettings( location:URLRequest ):void
        {
            _ldr = new URLLoader();
            _ldr.addEventListener( Event.COMPLETE, onSettingsLoaded, false, 0, true );
            _ldr.addEventListener( IOErrorEvent.IO_ERROR, onSettingsError, false, 0, true );
            _ldr.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSettingsError, false, 0, true );
            _ldr.load(location);
        }
        /**
         * 
         * @param e
         * 
         */        
        private function onSettingsError( e:Event ):void
        {
            dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, true ) );
        }
        /**
         * 
         * @param e
         * 
         */        
        private function onSettingsLoaded( e:Event ):void
        {
            try{
                parseSettings( XML(URLLoader(e.target).data) );
                dispatchEvent( new Event( Event.COMPLETE, true ) );
            }
            catch(e:Error){
                dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, true ) );
            }
        }
        /**
         * 
         * @param data
         * @return 
         * 
         */        
        public function parseSettings( data:XML ):Boolean
        {
            for each( var node:XML in data.children() ){
                _[node.name()] = node.hasSimpleContent()?node.children():node;
                if( node.hasComplexContent() )
                parseSettings( node );
            }
            return false;
        }
        
        /**
         * 
         */        
        public const _:Object = new Object();
    }
}