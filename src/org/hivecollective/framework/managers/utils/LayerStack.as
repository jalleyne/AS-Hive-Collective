package org.hivecollective.framework.managers.utils
{
	import flash.events.EventDispatcher;
	
	import org.hivecollective.framework.states.ILayeredState;
	import org.hivecollective.framework.states.StateController;

	public class LayerStack extends EventDispatcher
	{
		public function LayerStack()
		{
			super(null);
		}
		
		
		public var baseState:StateController;
		private var _layers:Array=[];
		
		public function push( layer:ILayeredState ):uint
		{
			return _layers.push(layer);
		}
		
		public function remove( layer:ILayeredState ):uint
		{
			var i:uint = _layers.indexOf(layer);
			_layers.splice(i,1);
			return _layers.length-1;
		}
		
		public function getPosition( layer:ILayeredState ):uint
		{
			return _layers.indexOf(layer);
		}
		
		public function getLayerByPosition( index:uint ):ILayeredState
		{
			return _layers[index];
		}
		
		public function getCurrentLayer( ):ILayeredState
		{
			return _layers[_layers.length-1];
		}
		
	}
}