package org.hivecollective.htmldom
{
    import flash.errors.IllegalOperationError;
    import flash.external.ExternalInterface;
    
    public class JSMethods
    {
        
        public static function getStyleSheetUrls():*
        {
            if( ExternalInterface.available )
            return ExternalInterface.call(JS_METHODS.getStyleSheetUrls);
            else throw new IllegalOperationError('allowScriptAccess must be set to either "samedomain" or "always" in order to use this method."');
        }
        
        
        /**
         * 
         */
                 
        public static const JS_METHODS:XML = 
        <methods>
            
            <getStyleSheetUrls><![CDATA[
            function()
            {
                var a = [];
                var link;
                var links = document.getElementsByTagName("link");
            
                for( l in links ){
                    link = links[l];
                    if( link.getAttribute && link.getAttribute("media") == "flashplayer" ){
                        var name = link.getAttribute("name");
                        var href = link.getAttribute("href");
                        a.push({href:href,name:name});
                    }
                }
                return a;
            }
            ]]></getStyleSheetUrls>
            
            <getElementById><![CDATA[
            function(id)
            {
                return document.getElementById(id).innerHTML;
            }
            ]]></getElementById>
            
        </methods>;
    }
}