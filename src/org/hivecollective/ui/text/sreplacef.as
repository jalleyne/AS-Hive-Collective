package org.hivecollective.ui.text
{
    public function sreplacef( val:String, ...replacements ):String
    {
        for each( var r:String in replacements )
        val = val.replace("%s",r);
        return val;
    }
}