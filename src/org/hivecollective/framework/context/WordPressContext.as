package org.hivecollective.framework.context
{
    import com.gregsczebel.managers.plugins.WordPressPageManager;
    
    import flash.external.ExternalInterface;
    
    import org.hivecollective.framework.HiveFramework;
    import org.hivecollective.framework.managers.plugins.AddressableStateManager;
    import org.hivecollective.htmldom.XmlDom;

    public class WordPressContext extends HiveMediaContext
    {
        public function WordPressContext()
        {
            super();
        }
        
        override public function configure(hive:HiveFramework):void
        {
            super.configure(hive);
            
            pageManager = new WordPressPageManager(hive);
            
            var d:XmlDom = new XmlDom();
            d.parse(ExternalInterface.call("WP_AS_HIVE.content"));
            data = d;
            
            var p:XmlDom = new XmlDom();
            p.parse(ExternalInterface.call("WP_AS_HIVE.pages"));
            pages = p;
            
        }
        
        public var pageManager:WordPressPageManager;
        
        public var pages:XmlDom;
    }
}