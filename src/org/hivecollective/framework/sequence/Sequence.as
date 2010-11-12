
/**
*
* Base object for describing the animation of a State.
*
* @author	Jovan Alleyne
* @version	1.0a
* @since	Flash 9
*
*/

package org.hivecollective.framework.sequence
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class Sequence extends EventDispatcher
	{
		/**
		* Flag set to determine if the sequence has
		* started animating.
		*
		* @private
		*/
		protected var _active:Boolean = false;

		/**
		* Unique name for this sequence.
		*
		* @private
		*/
		protected var _name:String;

		/**
		* Type of event that will trigger the complete event
		* to be fired from a sequence.
		*
		* @private
		* @see _completeEventSource;
		*/
		protected var _completeEventName:String;

		/**
		* Object that will trigger a complete event type.
		*
		* @private
		* @see _completeEventName
		*/
		protected var _completeEventSource:*;
		
		/**
		* Collection of actions that have been pushed onto
		* this sequence to describe the animations.
		*
		* @private
		* @see _REPOSITORY_PARAM
		*/
		protected var _REPOSITORY:Array = new Array();
		
		/**
		 * 
		 */		
		protected var _REPOSITORY_PARAM:Dictionary = new Dictionary( false );
		
		/**
		*
		* @param	name
		* @param	actions
		*/
		public function Sequence( name:String, actions:Array=null )
		{
			super();
			_name = name||mkName();
			
			if( actions )
				_REPOSITORY = actions;
		}
		
		/**
		*
		* @return
		*/
		public function get name( ):String
		{
			return _name;
		}
		
		/**
		*
		* @param	action
		* @param	object
		* @param	...args
		* @return
		*/
		public function pushBefore( action:*, object:*, ...args ):Number
		{
			if( args.length )
				_REPOSITORY_PARAM[ action ] = args;
			
			return pushAt( action, _REPOSITORY.indexOf( object )-1 );
		}

		/**
		*
		* @param	action
		* @param	object
		* @param	...args
		* @return
		*/
		public function pushAfter( action:*, object:*, ...args ):Number
		{
			if( args.length )
				_REPOSITORY_PARAM[ action ] = args;
			
			return pushAt( action, _REPOSITORY.indexOf( object )+1 );
		}
		
		/**
		*
		* @param	action
		* @param	position
		* @param	...args
		* @return
		*/
		public function pushAt( action:*, position:Number, ...args ):Number
		{
			if( args.length )
				_REPOSITORY_PARAM[ action ] = args;
			
			var slice1:Array = _REPOSITORY.slice( 0, position );
			var slice2:Array = _REPOSITORY.slice( position );
			
			slice1.push( action );
			_REPOSITORY = slice1.concat( slice2 );
			
			return slice1.length - 1;
		}
		
		/**
		*
		* @param	action
		* @param	...args
		* @return
		*/
		public function push( action:*, ...args ):Number
		{
			if( args.length )
				_REPOSITORY_PARAM[ action ] = args;
			
			return _REPOSITORY.push( action );
		}
		
		/**
		*
		* @param	num
		*/
		public function index( num:Number ):*
		{
			return _REPOSITORY[ num ];
		}
		
		/**
		 * 
		 * @param startIndex
		 * @param endIndex
		 * @return 
		 * 
		 */		
		public function slice( startIndex:Number=0, endIndex:Number=16777215 ):*
		{
			/*var seq:ActionSequence 		= new ActionSequence( _name, _REPOSITORY.slice( startIndex, endIndex ) );
			//var seq:ActionSequence 		= new ActionSequence( _name, _REPOSITORY.slice( startIndex, endIndex ) );
			
			seq.completeTriggerName 	= _completeEventName;
			seq.completeTriggerSource 	= _completeEventSource;

			if( _active ) {
				if( seq.length ) kill( );
			}*/

			return null;
		}
		
		/**
		 * 
		 * 
		 */		
		public function reset( ):void
		{
			_REPOSITORY.splice(0, _REPOSITORY.length);
			// remove all keys from the dictionary
			for (var key:Object in _REPOSITORY_PARAM) {
				delete _REPOSITORY_PARAM[key]; //removes the key
			}
		}
		
		
		/**
		* @private
		*/
		protected var _complete:Boolean = false;


		public function set complete( value:Boolean ):void
		{
		    _complete = value;
		}

		public function get complete( ):Boolean
		{
		    return _complete;
		}

		/**
		*
		* @return
		*/
		public function kill( ):void
		{
		    if( _completeEventSource ){
			_completeEventSource.removeEventListener( _completeEventName, handleSequenceEnd );
		    }
		}
		
		/**
		*
		* @return
		*/
		public function activate( ):void
		{
			if( _completeEventSource && _completeEventName && !_active ) {
				_active = true;
				_completeEventSource.addEventListener( _completeEventName, handleSequenceEnd, false, 0, true );
			}
		}
		
		/**
		*
		* @param	e
		* @return
		*/
		internal function handleSequenceEnd( e:Event ):void
		{
			_completeEventSource.removeEventListener( _completeEventName, handleSequenceEnd );
		}

		/**
		*
		* @param	action
		* @return
		*/
		public function getParams( action:* ):Array
		{
			return _REPOSITORY_PARAM[ action ];
		}

		//______________________________________________________________________________ GETTERS and SETTERS
		
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get length( ):Number
		{
			return _REPOSITORY.length;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get active( ):Boolean
		{
			return _active;
		}
		/**
		 * 
		 * @param eventName
		 * 
		 */		
		public function set completeTriggerName( eventName:String ):void
		{
			_completeEventName = eventName;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get completeTriggerName( ):String
		{
			return _completeEventName;
		}
		/**
		 * 
		 * @param source
		 * 
		 */		
		public function set completeTriggerSource( source:* ):void
		{
			_completeEventSource = source;
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get completeTriggerSource( ):*
		{
			return _completeEventSource;
		}
				
		/**
		* @private
		*/
		public override function toString():String
		{
			var returnString:String = "[Sequence \n \t" + _name ;
			returnString += "\t\t" + _REPOSITORY.toString( ) + " ]";
			
			return returnString;
		}
		
		
        /**
         * 
         */		
        protected static var _ldrCount:int=0;
        /**
         * 
         * @return 
         * 
         */        
        protected function mkName():String
        {
        	var c:String = super.toString().toLowerCase();
        	c = c.replace(/(\[object )?(\])?/g,'');
            return c+(++_ldrCount);
        }
	}
	
}
