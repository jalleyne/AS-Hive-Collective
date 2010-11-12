package org.hivecollective.framework.context
{
    import flash.events.EventDispatcher;
    
    import org.hivecollective.framework.HiveFramework;
    import org.hivecollective.framework.managers.LayoutManager;
    import org.hivecollective.framework.managers.LoadManager;
    import org.hivecollective.framework.managers.SequenceManager;
    import org.hivecollective.framework.managers.StateManager;
    import org.hivecollective.locale.Localizer;
    
    
    public class HiveCoreContext extends EventDispatcher
    {
        /**
         * 
         */        
        public var hive:HiveFramework;
        /**
         * 
         */        
        public var loadManager      :   LoadManager;
        /**
         * 
         */        
        public var layoutManager    :   LayoutManager;
        /**
         * 
         */        
        public var stateManager     :   StateManager;
        /**
         * 
         */        
        public var sequenceManager  :   SequenceManager;    
        
        /**
         * 
         */        
        public var data : Object;        
        /**
         * 
         */        
        public var localizer:Localizer;
        
        
        public var tracker:Object;
        /**
         * 
         * 
         */        
        public function HiveCoreContext()
        {
            super();
        }
        
        /**
         * 
         * @param hive
         * 
         */        
        public function configure(hive:HiveFramework):void 
        {
            loadManager         = new LoadManager(hive);
            layoutManager       = new LayoutManager(hive);   
        }
        
    }
}