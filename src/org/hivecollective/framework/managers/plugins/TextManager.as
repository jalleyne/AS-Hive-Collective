package org.hivecollective.framework.managers.plugins
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.text.StyleSheet;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Dictionary;
    
    import org.hivecollective.framework.HiveFramework;
    import org.hivecollective.framework.managers.Manager;
    import org.hivecollective.framework.sequence.Sequence;
    import org.hivecollective.htmldom.JSMethods;

    public class TextManager extends Manager
    {
        public function TextManager(hive:HiveFramework)
        {
            super(hive);
            init(hive);
        }
        
        protected function init(hive:HiveFramework):TextManager
        {
            if(HiveFramework.DEBUG_MODE){trace( "TextManager :: init" )}
            
            getStyleSheetsFromDocument();
            
            hive.registerManager(this);
            
            //_____________ Register Object :: DisplayObject
            function textFieldFunc( action:*, sequence:Sequence, positionInSequence:int ):void {
                var tf:TextField = action as TextField;
                var params:Array = sequence.getParams(action);
                tf = formatTextField(tf);
                if( params ){
                    var s:Object = params[0];
                    for( var p:String in s )
                    if( tf.hasOwnProperty(p) ) tf[p] = s[p];
                }
            }
            hive.sequenceManager.registerAction(TextField, textFieldFunc);
            return this;
        }
        
        protected function getStyleSheetsFromDocument():void
        {
            var sheets:Array = JSMethods.getStyleSheetUrls();
            var sheet:StyleSheet;
            for each( var s:Object in sheets ){
                loadStyleSheet(new URLRequest(s['href']),s['name']);
            }
        }
        
        
        private var _sheetCount:uint=0;
        private function loadStyleSheet(url:URLRequest,name:String):URLLoader
        {
            function onDomStyleSheetLoaded(e:Event):void
            {
                IEventDispatcher(e.target).removeEventListener(e.type,arguments.callee);
                var ldr:URLLoader = e.target as URLLoader;
                var s:StyleSheet = new StyleSheet();
                s.parseCSS(ldr.data);
                addStyleSheet(s,name||getStyleSheet()?"domStyleSheet_"+_sheetCount:"css");
            }
            
            var ldr:URLLoader = new URLLoader();
            ldr.addEventListener(Event.COMPLETE, onDomStyleSheetLoaded);
            ldr.load(url);
            return ldr;
        }
        
        
        
        public function formatTextField( p_field:TextField ):TextField
        {
            p_field.styleSheet = getStyleSheet();
            p_field.autoSize = TextFieldAutoSize.LEFT;
            return p_field;
        }
        
        /**
         * 
         */        
        private const _styleSheetsByName:Dictionary = new Dictionary();
        
        /**
         * 
         */        
        private const _styleSheets:Dictionary = new Dictionary(true);
        
        /**
         * 
         * @param p_styleSheet
         * @param p_styleSheetName
         * 
         */        
        public function addStyleSheet( p_styleSheet:StyleSheet, p_styleSheetName:String='css' ):void
        {   
            if ( _styleSheets[ p_styleSheet ] ) 
            throw new ArgumentError( "this StyleSheet instance is already set with the name" + p_styleSheetName );
            
            if ( _styleSheetsByName[ p_styleSheetName ] ) 
            throw ArgumentError( "a StyleSheet instance is already set with the name " + p_styleSheetName );
            
            _styleSheets[ p_styleSheet ] = p_styleSheetName;
            _styleSheetsByName[ p_styleSheetName ] = p_styleSheet;
            
            ++_sheetCount;
        }
        
        /**
         * 
         * @param p_styleSheet
         * @return 
         * 
         */        
        public function removeStyleSheet( p_styleSheet:StyleSheet ):Boolean
        {
            if( _styleSheets[ p_styleSheet ] ){
                delete _styleSheetsByName[ _styleSheets[ p_styleSheet ] ];
                delete _styleSheets[ p_styleSheet ];
                return true;   
            }
            else return false;
        }
        
        /**
         * 
         * @param p_styleSheetName
         * @return 
         * 
         */        
        public function removeStyleSheetByName( p_styleSheetName:String ):Boolean
        {
            return removeStyleSheet( getStyleSheet(p_styleSheetName) );
        }
        
        /**
         * 
         * @param p_styleSheetName
         * @return 
         * 
         */        
        public function getStyleSheet( p_styleSheetName:String='css' ):StyleSheet
        {
            return _styleSheetsByName[ p_styleSheetName ];
        }
        
    }
}