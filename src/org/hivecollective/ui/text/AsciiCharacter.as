package org.hivecollective.ui.text
{
    public final class AsciiCharacter
    {
        /**
         * 
         */        
        public var asciiCode    : uint;
        /**
         * 
         */
        public var hexCode      : uint;
        /**
         * 
         */        
        public var symbol       : String = "";
        /**
         * 
         * @param p_symbol
         * @param p_ascii
         * @param p_hex
         * 
         */        
        public function AsciiCharacter(p_symbol:String,p_ascii:uint,p_hex:uint)
        {
            symbol      = p_symbol;
            asciiCode   = p_ascii;
            hexCode     = p_hex;
        }
        
        
        public function toString():String
        {
            return "[Character[ symbol : "+symbol + " ascii : " + asciiCode + " hex : " + hexCode + "]]";
        }
    }
}