package org.hivecollective.framework.context
{
    import org.hivecollective.framework.HiveFramework;
    import org.hivecollective.framework.managers.plugins.SoundManager;

    public class HiveMediaContext extends HiveCoreContext
    {
        /**
         * 
         */        
        public var soundManager:SoundManager;
        
        /**
         * 
         * 
         */        
        public function HiveMediaContext()
        {
            super();
        }
        
        /**
         * 
         * @param hive
         * 
         */        
        override public function configure(hive:HiveFramework):void 
        {
            super.configure(hive);
            soundManager = new SoundManager(hive);
        }
    }
}