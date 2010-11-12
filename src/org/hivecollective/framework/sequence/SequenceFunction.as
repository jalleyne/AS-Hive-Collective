/**
* ...
* @author Default
* @version 0.1
*/

package org.hivecollective.framework.sequence
{
	import flash.events.EventDispatcher;

	public class SequenceFunction extends EventDispatcher
	{
        /**
        *
        */
		private var __scope:Object;

        /**
        *
        */
		private var __method:Function;

        /**
        *
        */
		private var __arguments:Array;

        /**
        *
        * @param	methodScope
        * @param	method
        * @param	...args
        */
        public function SequenceFunction( methodScope:Object, method:Function, ...args )
        {
            __scope = methodScope;
            __method = method;
            __arguments = args;
        }

        /**
        *
        * @return
        */
        public function get scope( ):Object
        {
            return __scope;
        }

        /**
        *
        * @return
        */
        public function get method( ):Function
        {
            return __method;
        }

        /**
        *
        * @return
        */
        public function get argumentsList( ):Array
        {
            return __arguments;
        }
	}
	
}
