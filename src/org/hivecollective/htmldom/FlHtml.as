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
    import flash.utils.Dictionary;

	/**
	 * 
	 * @author jovanalleyne
	 * 
	 * @description This class is designed to parse and transform HTML return 
	 * by using Javascript and adapt it to work with ActionScript TextField.
	 * Most commonly the issue has been the stripping of quotes by IE (only 
	 * versions 6 & 7 have been tested). As a result of unquoted attributes like
	 * id=12 your TextField will not display any text using the htmlText method.
	 * 
	 */	
	public class FlHtml
	{
		
		/**
		 * @private const
		 * Regular Expression to find tags containing attributes 
		 * with no quotes.
		 */		
        private static const TAG_EXP:RegExp = new RegExp( /<(\/)?\w+(?: +(?:\w+=)(?:['|"]?[#\w0-9\-\?=.: \/&;'\+]*['|"]?))*(\/)?>/ig );
        
		/**
		 * @private const
		 * Regular Expression to find attributes in tags and break 
		 * them into groups.
		 */		
		private static const ATTRIBUTE_EXP:RegExp = new RegExp( / ([a-zA-Z0-9_]+=)([#\w0-9'.:\-\?=\/&;\+]+)/ig );
		
		/**
         * @private const
         * Regular Expression to find uppercase tag names. Mostly implemented to counter IE's 
         * uppercasing of tag names. 
         */ 	
		private static const UPPERCASE_TAG_EXP:RegExp = new RegExp( /(<(\/)?[A-Z0-9_]+).*(\/)?>/g );
        
		/**
         * @private const
         * Regular Expression to find list items (li) that are not closed in IE.
         */     
		private static const LI_CLOSE_EXP:RegExp = new RegExp( /(<(\/)?(li|ol|ul)).*>/ig );
		
        
        private static const IMG_CLOSE:RegExp = new RegExp( /<img (src=['|"]?[#\w\-\?=.: \/&;]*['|"]?)( +(?:\w+=)(?:['|"]?[#\w\-\?=.: \/&;\+]*['|"]?))* *>/igm );
        
        
        
		/**
		 * 
		 * @param p_value
		 * @return String containing HTML tag adapted to be compatible with ActionScript's
		 * XML. As more compatibility differences arise, methods to transform this HTML
		 * into a String that ActionScript can render with the htmlText method of TextField
		 * can be added to this method.  
		 *   
		 * 
		 */		
		public static function adapt( p_value:String ):String
		{	
            
			var r:Object = TAG_EXP.exec(p_value);
            var listTagCloseLUT:Dictionary = new Dictionary();
			var t:String;
			while (r != null) 
			{
				// add quotes to attributes
                p_value = p_value.replace( r[0], t=quoteAttributes( r[0] ) );
                r[0] = t;
                p_value = p_value.replace( r[0], t=lowercaseTagsAttributes( r[0] ) );
                r[0] = t;
                p_value = p_value.replace( r[0], t=closeImgTag( r[0] ) );
                r[0] = t;
                
                t=closeListTags( r[0] )
                
                if( !listTagCloseLUT[r[0]] && 
                    t != r[0] ) 
                {
                    listTagCloseLUT[r[0]] = t;
                }
                
				// continue checking
				r = TAG_EXP.exec( p_value );
			}
            
            p_value = replaceListTags(p_value,listTagCloseLUT);
            
			_prevTag = "";
			
			return p_value;
		}
        
        private static function replaceListTags(p_value:String,listTagCloseLUT:Dictionary):String
        {
            for( var t:String in listTagCloseLUT )
                p_value = p_value.replace(new RegExp(t,'g'),listTagCloseLUT[t]);
            return p_value.replace(new RegExp(/(<[o|u]l>\s*)<\/li>/igm),"$1");
        }
        
        private static function closeImgTag(p_tag:String):String
        {
            if( p_tag.match(IMG_CLOSE).length )
                return p_tag.replace(">","/>");
            
            return p_tag;
        }
        
        /**
		 * 
		 */		
		private static var _prevTag:String="";
		
        /**
		 * 
		 * @param p_tag
		 * @return 
		 * 
		 */
		private static function closeListTags(p_tag:String):String
		{
		    var t:String;
		    var a:Object = LI_CLOSE_EXP.exec( p_tag );
            while ( a != null ){
                t = a[1];
                switch(a[1])
                {
                    case "</li":
                    break;
                    
                    case "<li":
                    case "</ul":
                    case "</ol":
                    
                    if( _prevTag != "</li" && 
                        _prevTag != "<ol" && 
                        _prevTag != "<ul" )
                    t = "</li>\r\n" + a[1];
                    
                    break;
                    
                    case "<ul":
                    case "<ol":
                    break;
                }
                p_tag = String(p_tag).replace( a[1], t );
                
                _prevTag = a[1];
                a = LI_CLOSE_EXP.exec( p_tag );
            }
            
            return p_tag;
		}
		/**
		 * 
		 * @param p_tag
		 * @return 
		 * 
		 */		
		private static function lowercaseTagsAttributes(p_tag:String):String
		{
		    var a:Object = UPPERCASE_TAG_EXP.exec( p_tag );
            while ( a != null ){
                p_tag = String(p_tag).replace( a[1], String(a[1]).toLowerCase() );
                a = UPPERCASE_TAG_EXP.exec( p_tag );
            }
		    return p_tag;
		}


		/**
		 * 
		 * @param p_tag
		 * @return String containing HTML tag properly quoted for use with TextField.
		 * 
		 */		
		private static function quoteAttributes( p_tag:String ):String
		{
			var a:Object = ATTRIBUTE_EXP.exec( p_tag );
			while ( a != null ){
				p_tag = String(p_tag).replace( a[0], " " + a[1] + "\"" + a[2] + "\"" );
				a = ATTRIBUTE_EXP.exec( p_tag );
			}
			return p_tag;
		}
	
	}
}