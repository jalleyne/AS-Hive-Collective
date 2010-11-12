package org.hivecollective.net
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import org.hivecollective.net.IURLLoaderDelegate;
    
    public class MultipartLoader extends URLLoader
    {
        /**
         * 
         */        
        public var boundaryLength:uint = 0x20;
        /**
         * 
         */        
        public var boundary:String;
        /**
         * 
         */        
        private var _byteData:ByteArray;
        
        /**
         * 
         */        
        protected var _delegate:IURLLoaderDelegate;
        /**
         * 
         */        
        public const NEW_LINE:uint          = 0x0d0a;
        /**
         * 
         */        
        public const DOUBLE_QUOTE:uint      = 0x22;
        /**
         * 
         */        
        public const DASHES:uint            = 0x2d2d;
        
        
        /**
         * 
         * 
         */        
        public function MultipartLoader()
        {
            super(null);
        }
        
        /**
         * 
         * @param vars
         * @param files
         * @param url
         * @param delegate
         * @return 
         * 
         */        
        public function request( vars:Array, files:Array, url:String=null, delegate:IURLLoaderDelegate=null ):MultipartLoader
        {
            if( !boundary || (boundary && !boundary.length) ) 
                boundary = createBoundary();
            
            createByteData(vars, files);
            
            //
            var req:URLRequest  = new URLRequest();
            req.url             = url;
            req.method          = URLRequestMethod.POST;

            //
            req.data            = _byteData;
            
            //
            req.requestHeaders.push( 
                new URLRequestHeader( "Content-type", "multipart/form-data; boundary=" + boundary )
            );

            //
            if(_delegate)
                unregisterDelegate(_delegate);
            
            if(delegate)
                registerDelegate(delegate);
            
            _delegate = delegate;
            
            
            //
            dataFormat = URLLoaderDataFormat.BINARY;
            load(req);
            //
            return this;
        }
        
        /**
         * 
         * @param vars
         * @param files
         * @return 
         * 
         */        
        protected function createByteData( vars:Array, files:Array ):ByteArray
        {
            _byteData = new ByteArray();
            _byteData.endian = Endian.BIG_ENDIAN;
            
            // write name value paris
            writeFormData( _byteData, vars );
            
            // files            
            writeFileData( _byteData, files );
            
            //
            closeBoundary( _byteData, boundary );
            _byteData.writeShort( NEW_LINE );
            
            //
            return _byteData;
        }
        /**
         * 
         * @param bytes
         * @param vars
         * @return 
         * 
         */        
        protected function writeFormData( bytes:ByteArray, vars:Array ):ByteArray
        {
            for each( var arg:Object in vars ){
                
                for( var field:String in arg ){
                    // begin name value pair
                    writeBoundary(bytes, boundary );
                    
                    // set content disposition
                    bytes.writeUTFBytes( "Content-Disposition: form-data; name=" );
                    // add quote
                    bytes.writeByte( DOUBLE_QUOTE );
                    // write name
                    bytes.writeUTFBytes( field );
                    // end quote
                    bytes.writeByte( DOUBLE_QUOTE );
                    // new lines
                    bytes.writeShort( NEW_LINE );
                    bytes.writeShort( NEW_LINE );
                    
                    // write value
                    bytes.writeUTFBytes( arg[field] );
                    bytes.writeShort( NEW_LINE );
                }
            }
            return bytes;
        }
        /**
         * 
         * @param bytes
         * @param files
         * @return 
         * 
         */        
        protected function writeFileData( bytes:ByteArray, files:Array ):ByteArray
        {
            for each( var file:Object in files ){
                writeBoundary( bytes, boundary );
                
                // write file disposition
                bytes.writeUTFBytes( "Content-Disposition: form-data; name=\"Filename\"" );
                bytes.writeShort( NEW_LINE );
                bytes.writeShort( NEW_LINE );
                bytes.writeUTFBytes( file.filename );
                bytes.writeShort( NEW_LINE );
                
                writeBoundary( bytes, boundary );
                
                // write content disposition
                bytes.writeUTFBytes( "Content-Disposition: form-data; name=\"" + file.name + "\"; filename=\"" + file.filename + "\"" );
                bytes.writeShort( NEW_LINE );
                bytes.writeUTFBytes( "Content-Type: " + file.type );
                bytes.writeShort( NEW_LINE );
                bytes.writeShort( NEW_LINE );
                
                //
                bytes.writeBytes( 
                    file.content, 
                    0, 
                    ByteArray(file.content).length 
                );
                bytes.writeShort( NEW_LINE );
            }
            return bytes;
        }
        
        /**
         * 
         * @param bytes
         * @param partBoundary
         * @return 
         * 
         */        
        protected function writeBoundary( bytes:ByteArray, partBoundary:String ):ByteArray
        {
            bytes.writeShort( DASHES );
            bytes.writeUTFBytes( partBoundary );
            bytes.writeShort( NEW_LINE );
            
            return bytes;
        }
        /**
         * 
         * @param bytes
         * @param partBoundary
         * @return 
         * 
         */        
        protected function closeBoundary( bytes:ByteArray, partBoundary:String ):ByteArray
        {
            bytes.writeShort( NEW_LINE );
            bytes.writeShort( DASHES );
            bytes.writeUTFBytes( partBoundary );
            bytes.writeShort( DASHES );
            
            return bytes; 
        }

        /**
         * 
         * @return 
         * 
         */        
        public function createBoundary():String
        {
            var b:String = "";
            var c:String;
            for( var i:uint = 0; i < boundaryLength; ++i ){
                c = String.fromCharCode( 
                                int( Math.random() > 0.5 ? 
                                    Math.random() * 25 + 97 : 
                                    Math.random() * 9 + 48 
                                ) 
                );
                b = b.concat(
                        Math.random() > 0.5 ? c.toUpperCase() : c
                    );
            }
            return b;
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