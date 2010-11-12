/**
 * 
 */
package org.hivecollective.ui.text
{
    /**
     * 
     * @author jovan
     * 
     */
    public class DefaultKeyboardCharacterSet
    {
        /**
         * 
         */        
        public static const ASCII_TABLE : Array = [];
        {
            //commands
            ASCII_TABLE[0x00] = new AsciiCharacter("NUL",0,0x00);
            ASCII_TABLE[0x08] = new AsciiCharacter("BS",8,0x08);
            
            ASCII_TABLE[0x8F] = new AsciiCharacter("NEXT",143,0x8F);
            ASCII_TABLE[0x90] = new AsciiCharacter("PREV",144,0x90);
            
            //punctuation
            ASCII_TABLE[0x20] = new AsciiCharacter(" ",32,0x20);
            ASCII_TABLE[0x27] = new AsciiCharacter("'",39,0x27);
            ASCII_TABLE[0x2C] = new AsciiCharacter(",",44,0x2C);
            ASCII_TABLE[0x2D] = new AsciiCharacter("-",45,0x2D);
            ASCII_TABLE[0x2E] = new AsciiCharacter(".",46,0x2E);

            // numbers
            ASCII_TABLE[0x30] = new AsciiCharacter("0",48,0x30);
            ASCII_TABLE[0x31] = new AsciiCharacter("1",49,0x31);
            ASCII_TABLE[0x32] = new AsciiCharacter("2",50,0x32);
            ASCII_TABLE[0x33] = new AsciiCharacter("3",51,0x33);
            ASCII_TABLE[0x34] = new AsciiCharacter("4",52,0x34);
            ASCII_TABLE[0x35] = new AsciiCharacter("5",53,0x35);
            ASCII_TABLE[0x36] = new AsciiCharacter("6",54,0x36);
            ASCII_TABLE[0x37] = new AsciiCharacter("7",55,0x37);
            ASCII_TABLE[0x38] = new AsciiCharacter("8",56,0x38);
            ASCII_TABLE[0x39] = new AsciiCharacter("9",57,0x39);
            
            //letters
            ASCII_TABLE[0x41] = new AsciiCharacter("A",65,0x41);
            ASCII_TABLE[0x42] = new AsciiCharacter("B",66,0x42);
            ASCII_TABLE[0x43] = new AsciiCharacter("C",67,0x43);
            ASCII_TABLE[0x44] = new AsciiCharacter("D",68,0x44);
            ASCII_TABLE[0x45] = new AsciiCharacter("E",69,0x45);
            ASCII_TABLE[0x46] = new AsciiCharacter("F",70,0x46);
            ASCII_TABLE[0x47] = new AsciiCharacter("G",71,0x47);
            ASCII_TABLE[0x48] = new AsciiCharacter("H",72,0x48);
            ASCII_TABLE[0x49] = new AsciiCharacter("I",73,0x49);
            ASCII_TABLE[0x4A] = new AsciiCharacter("J",74,0x4A);
            ASCII_TABLE[0x4B] = new AsciiCharacter("K",75,0x4B);
            ASCII_TABLE[0x4C] = new AsciiCharacter("L",76,0x4C);
            ASCII_TABLE[0x4D] = new AsciiCharacter("M",77,0x4D);
            ASCII_TABLE[0x4E] = new AsciiCharacter("N",78,0x4E);
            ASCII_TABLE[0x4F] = new AsciiCharacter("O",79,0x4F);
            ASCII_TABLE[0x50] = new AsciiCharacter("P",80,0x50);
            ASCII_TABLE[0x51] = new AsciiCharacter("Q",81,0x51);
            ASCII_TABLE[0x52] = new AsciiCharacter("R",82,0x52);
            ASCII_TABLE[0x53] = new AsciiCharacter("S",83,0x53);
            ASCII_TABLE[0x54] = new AsciiCharacter("T",84,0x54);
            ASCII_TABLE[0x55] = new AsciiCharacter("U",85,0x55);
            ASCII_TABLE[0x56] = new AsciiCharacter("V",86,0x56);
            ASCII_TABLE[0x57] = new AsciiCharacter("W",87,0x57);
            ASCII_TABLE[0x58] = new AsciiCharacter("X",88,0x58);
            ASCII_TABLE[0x59] = new AsciiCharacter("Y",89,0x59);
            ASCII_TABLE[0x5A] = new AsciiCharacter("Z",90,0x5A);
            
            //special characters
            ASCII_TABLE[0x8C] = new AsciiCharacter("Œ",140,0x8C);
            ASCII_TABLE[0xC0] = new AsciiCharacter("À",192,0xC0);
            ASCII_TABLE[0xC2] = new AsciiCharacter("Â",194,0xC2);
            ASCII_TABLE[0xC4] = new AsciiCharacter("Ä",196,0xC4);
            ASCII_TABLE[0xC6] = new AsciiCharacter("Æ",198,0xC6);
            ASCII_TABLE[0xC7] = new AsciiCharacter("Ç",199,0xC7);
            ASCII_TABLE[0xC8] = new AsciiCharacter("È",200,0xC8);
            ASCII_TABLE[0xC9] = new AsciiCharacter("É",201,0xC9);
            ASCII_TABLE[0xCA] = new AsciiCharacter("Ê",202,0xCA);
            ASCII_TABLE[0xCB] = new AsciiCharacter("Ë",203,0xCB);
            ASCII_TABLE[0xCE] = new AsciiCharacter("Î",206,0xCE);
            ASCII_TABLE[0xCF] = new AsciiCharacter("Ï",207,0xCF);
            ASCII_TABLE[0xD4] = new AsciiCharacter("Ô",212,0xD4);
            ASCII_TABLE[0xD9] = new AsciiCharacter("Ù",217,0xD9);
            ASCII_TABLE[0xDB] = new AsciiCharacter("Û",219,0xDB);
        }
        
    }
}