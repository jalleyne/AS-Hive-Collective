package org.hivecollective.locale
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    public class Localizer extends EventDispatcher
    {       
        /**
         * 
         */        
        public var currentLocale:String = Localizations.EN;
        /**
         * 
         */        
        public var stringsObject:Object;
        /**
         * 
         * 
         */        
        public function Localizer()
        {
            super(null);
        }
        /**
         * 
         * @param val
         * @param table
         * @param lang
         * @return 
         * 
         */        
        public function translate(val:String,table:Object=null,lang:String=null):String
        {
            table = table || stringsObject;
            lang = lang ? lang : currentLocale;
            
            var o:Object = table[val];
            return String(o && o[lang] ? o[lang] :val);
        }
        
        
    }
}