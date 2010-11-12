/*          ._
*            '.			     _______ _______ ___ ___ _______ 
*     --._     \    .-.		|   |   |_     _|   |   |    ___|
*         '. .--;  /  |		|       |_|   |_|   |   |    ___|
*         ,;/ ^  |`\  /.-"".   |___|___|_______|\_____/|_______|	
*        ;' \  _/   |'    .'          code.google.com/p/as-hive
*       /    `.;I> /_.--.` )    __
*      |    .'`  .'( _.Y/`;    /  \__
*       \_.'---'`   `\  `-/`-. \__/  \__
*         /_-.`-.._ _/`\  ;-./_/  \__/  \
*        |   -./  ;.__.'`\  /  \__/  \__/
*         `--'   (._ _.'`|  \__/  \__/
*                /     ./ __/  \__/  \
*           jgs ; `--';'_/  \__/  \__/
*               `;-,-'/  \__/  \
*               ,'`   \__/  \__/
*
* Copyright 2009 (c) Jovan Alleyne, Peter Nitsch, Brandon Flowers.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 * @author	Jovan Alleyne, Peter Nitsch, Brandon Flowers
 * @version	1.0a
 * @since	Flash 9
 */

package org.hivecollective.htmldom
{
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    
    /**
     * 
     * @author jovan
     * 
     */
    public class XmlDom extends EventDispatcher
    {
        /**
         * 
         * 
         */        
        public function XmlDom()
        {
            super(null);
        }
        
        
        //________________________________________________ PARSING METHODS
        
        
        /**
         * 
         * @param id
         * 
         */
        
        public function parseNode( id:String ):void
        {
            if( ExternalInterface.available )
            parse(
                FlHtml.adapt(
                    ExternalInterface.call(JS_METHODS.getElementById,id)
                )
            );
            else throw new IllegalOperationError('allowScriptAccess must be set to either "samedomain" or "always" in order to use this method."');
        }
        
        /**
         * 
         */        
        private var _data:XML;
        
        /**
         * 
         * @return 
         * 
         */        
        public function getData():XML
        {
            return _data;
        }
        
        /**
         * 
         * @param value
         * @return 
         * 
         */        
        public function parse( val:String ):XML
        {
            if( val && val.length ){
                try{
                    _data = XML('<hive>'+val+'</hive>');
                }
                catch(e:TypeError)
                {
                    trace(e,val);
                }
            }
            else throw new ArgumentError("DOM value cannot be an empty string or null: \r\n\tvalue = "+val+"\r\n");
            
            return _data;
        }
        
        //________________________________________________ JAVASCRIPT METHODS
        
        /**
         * 
         */        
        private const JS_METHODS:XML = 
        <methods>
            <getElementById><![CDATA[
            function(id)
            {
                return document.getElementById(id).innerHTML;
            }
            ]]></getElementById>
        </methods>;
        
    }
}