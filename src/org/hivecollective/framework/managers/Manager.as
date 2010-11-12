package org.hivecollective.framework.managers
{
	import flash.events.EventDispatcher;
	
	import org.hivecollective.framework.HiveFramework;

	public class Manager extends EventDispatcher
	{
		protected var hive:HiveFramework;
		
		public function Manager(hive:HiveFramework)
		{
			this.hive = hive;
			super(null);
		}
		
	}
}