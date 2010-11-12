package org.hivecollective.net
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    public class URLData extends URLLoader
    {
        /**
         * 
         */        
        public var method:String = URLRequestMethod.GET;
        
        /**
         * 
         */		
        public var URL:URLRequest;
        /**
         * 
         */        
        public var _requestData:Object;
        /**
         * 
         */        
        public var name:String;
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
        protected var _delegate:IURLLoaderDelegate;
        /**
         * 
         * @param request
         * 
         */        
        public function URLData(p_request:URLRequest=null, p_name:String=null)
        {
            super();
            
            name  = p_name;
            URL = p_request;
        }
        
        /**
         * 
         * @return 
         * 
         */
        public function get requestData():Object
        {
            return _requestData;
        }
        
        /**
         * 
         * @param data
         * @param delegate
         * @return 
         * 
         */        
        public function request( data:URLVariables=null, delegate:IURLLoaderDelegate=null ):URLData
        {
            var req:URLRequest  = URL;
            req.method          = method;
            req.data            = data;
            
            _requestData = data;
            
            //
            if(_delegate)
            unregisterDelegate(_delegate);
            
            if(delegate)
            registerDelegate(delegate);
            
            _delegate = delegate;
            
            //
            load(req);
            //
            return this;
        }
        /**
         * 
         * @return 
         * 
         */        
        public function get responseAsXML():XML
        {
            try{
                return XML(data);
            }
            catch(e:Error){}
            
            return data.toString();
        }
        
        /**
         * 
         * @param delegate
         * 
         */        
        protected function registerDelegate(delegate:IURLLoaderDelegate):void
        {
            addEventListener(Event.OPEN,            delegate.onURLRequestOpen);
            addEventListener(ProgressEvent.PROGRESS,delegate.onURLRequestProgress);
            addEventListener(IOErrorEvent.IO_ERROR, delegate.onURLRequestError);
            addEventListener(Event.COMPLETE,        delegate.onURLRequestComplete);
            
            addEventListener(Event.COMPLETE,                    delegateCleanup);
            addEventListener(IOErrorEvent.IO_ERROR,             delegateCleanup);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, delegateCleanup);
        }
        /**
         * 
         * @param delegate
         * 
         */        
        protected function unregisterDelegate(delegate:IURLLoaderDelegate):void
        {
            removeEventListener(Event.OPEN,            delegate.onURLRequestOpen);
            removeEventListener(ProgressEvent.PROGRESS,delegate.onURLRequestProgress);
            removeEventListener(IOErrorEvent.IO_ERROR, delegate.onURLRequestError);
            removeEventListener(Event.COMPLETE,        delegate.onURLRequestComplete);
            
            removeEventListener(Event.COMPLETE,                    delegateCleanup);
            removeEventListener(IOErrorEvent.IO_ERROR,             delegateCleanup);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, delegateCleanup);
        }
        /**
         * 
         * @param e
         * 
         */        
        protected function delegateCleanup(e:Event):void
        {
            unregisterDelegate(_delegate);
        }
    }
}