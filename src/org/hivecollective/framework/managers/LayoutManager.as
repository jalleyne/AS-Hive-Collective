package org.hivecollective.framework.managers
{
    
    import flash.display.*;
    import flash.events.FullScreenEvent;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    import org.hivecollective.framework.HiveFramework;
    import org.hivecollective.framework.managers.utils.LayoutArrangement;
    import org.hivecollective.framework.sequence.ActionSequence;
    import org.hivecollective.framework.sequence.CloseSequence;
    import org.hivecollective.framework.sequence.Sequence;
    import org.hivecollective.framework.states.ILayeredState;
    import org.hivecollective.framework.states.ISWFState;
    import org.hivecollective.framework.states.IStateTransition;
    import org.hivecollective.framework.states.SWFStateController;
    import org.hivecollective.net.LoaderData;

    /**
     * 
     * @author jovan
     * 
     */    
    public class LayoutManager extends Manager
    {
        //________________________________________________ PROPERTIES
        
        /**
         * 
         */       
        private var _canvas : DisplayObjectContainer;
        /**
         * 
         */		
        private var _canvasWidth : Number = 0;
        /**
         * 
         */		
        private var _canvasHeight : Number = 0;
        
        /**
         * 
         * @return 
         * 
         */        
        public function get canvas():DisplayObjectContainer
        {
            return _canvas;
        }
        
        //________________________________________________ CONSTRUCTOR
        
        /**
         * 
         * @param hive
         * 
         */		
        public function LayoutManager(hive:HiveFramework, canvas:DisplayObjectContainer=null):void
        {
            super(hive);
            init(hive,canvas);
        }
        /**
         * 
         * @param hive
         * @param canvas
         * @return 
         * 
         */		
        protected function init(hive:HiveFramework,canvas:DisplayObjectContainer=null):LayoutManager
        {
            if(HiveFramework.DEBUG_MODE){trace( "LayoutManager :: init" )}
            
            hive.registerManager(this);
            var manager:LayoutManager = this;
            //_____________ Register Object :: DisplayObject
            function displayObjectFunc( action:*, sequence:Sequence, positionInSequence:int ):void {
                var state:ISWFState = hive.stateManager.currentState as ISWFState;
                if( sequence is ActionSequence ){
                    
                    if( viewIsForCurrentState(action) ){
                        state.viewWillBeAdded(manager);
                    }
                    
                    if( sequence.getParams(action) != null){
                        manager.addChildAt( action, sequence.getParams(action)[0] );
                    } else manager.addChild(action);
                    
                    if( viewIsForCurrentState(action) ){
                        state.viewWasAdded(manager);
                    }
                }
                else if( sequence is CloseSequence )
                {
                    if( viewIsForCurrentState(action) ){
                        state.viewWillBeRemoved(manager);
                    }
                    
                    if( action is DisplayObject && DisplayObject(action).parent )
                        DisplayObject(action).parent.removeChild(action);
                    
                    if( viewIsForCurrentState(action) ){
                        state.viewWasRemoved(manager);
                    }
                    
                }
            }
            
            hive.sequenceManager.registerAction(DisplayObject, displayObjectFunc);
            
            _canvas = canvas || hive.canvas;
            
            _canvas.stage.align     = StageAlign.TOP;
            _canvas.stage.scaleMode = StageScaleMode.NO_SCALE;
            
            return this;
        }
        /**
         * 
         * @param view
         * @return 
         * 
         */        
        public function viewIsForCurrentState(view:DisplayObject):Boolean
        {
            return hive.stateManager.currentState && 
                hive.stateManager.currentState is SWFStateController &&
                SWFStateController(hive.stateManager.currentState).view == view;
        }
        
        /**
         * 
         */		
        private var _stateTransition:IStateTransition;
        
        
        /**
         * 
         * @param transition
         * 
         */        
        public function setSWFStateTransition( transition:org.hivecollective.framework.states.IStateTransition ):void
        {
            function transitionFunc( action:*, sequence:Sequence, positionInSequence:int ):void
            {
                var curState:SWFStateController = hive.stateManager.currentState as SWFStateController;
                if( curState && curState.view == action && !(curState is ILayeredState) ){
                    if( sequence is ActionSequence ){
                        _stateTransition.openTransition( action as LoaderData, 
                            sequence as ActionSequence, positionInSequence );
                    }
                    else if( sequence is CloseSequence ) {
                        _stateTransition.closeTransition( action as LoaderData, 
                            sequence as CloseSequence, positionInSequence );
                    }
                }
            }
            _stateTransition = transition;
            hive.sequenceManager.registerAction(LoaderData, transitionFunc);
        }
        
        
        
        //________________________________________________ DISPLAY LIST METHODS
        
        /**
         * 
         * @param child
         * @param alignment
         * 
         */		
        public function autoAlign( child:DisplayObject, alignment:String ):void
        {
            
        }
        
        
        /**
         *
         * @param	element
         * @param	index
         * @return
         */
        private function buildElement( element:*, index:int=-1 ):DisplayObject
        {
            if( index > -1 ){
                _canvas.addChildAt( element, index );
            }else{
                _canvas.addChild( element );
            }
            
            invalidateAlwaysOnTop();
            
            return element as DisplayObject;
        }
        
        
        /**
         * 
         */        
        protected var ALWAYS_ON_TOP:Dictionary = new Dictionary(true);
        
        /**
         * 
         * @param p_child
         * 
         */        
        public function alwaysOnTop( p_child:DisplayObject ):void
        {
            ALWAYS_ON_TOP[ p_child ] = p_child;
        }
        /**
         * 
         * 
         */        
        protected function invalidateAlwaysOnTop():void
        {
            if( !(hive.stateManager.currentState is ILayeredState) ){
                for each( var child:DisplayObject in ALWAYS_ON_TOP )
                _canvas.setChildIndex( child, _canvas.numChildren-1 );
            }
        }
        
        /**
         *
         * @param	arrangement
         * @param	target
         * @param	relativeTo
         */
        public function arrange( arrangement:String, target:DisplayObject, relativeTo:DisplayObject=null ):int
        {
            if( !_canvas.contains( target ) ) return -1;
            
            var index:Number = -1;
            switch( arrangement ){
                
                case LayoutArrangement.BRING_TO_BACK:
                    index = 0
                    break;
                
                case LayoutArrangement.BRING_TO_FRONT:
                    index = _canvas.numChildren - 1;
                    break;
                
                case LayoutArrangement.BRING_BACKWARD:
                    index = _canvas.getChildIndex( target ) - 1;
                    break;
                
                case LayoutArrangement.BRING_FORWARD:
                    index = _canvas.getChildIndex( target ) + 1;
                    break;
                
                case LayoutArrangement.BEHIND:
                    index = _canvas.getChildIndex( relativeTo );
                    break;
                
                case LayoutArrangement.INFRONT:
                    index = _canvas.getChildIndex( relativeTo ) + 1;
                    break;
            }
            
            if( index != -1 )	_canvas.setChildIndex( target, index );
            
            invalidateAlwaysOnTop();
            
            return index;
        }
        
        /**
         * 
         */        
        public var viewportRect:Rectangle = new Rectangle(0,0,900,680);
        
        /**
         *
         * @param	child
         * @return
         */
        public function getChildIndex( child:DisplayObject ):int
        {
            return _canvas.getChildIndex( child );
        }
        
        /**
         *
         * @param	child
         * @return
         */
        public function addChild( child:DisplayObject ):DisplayObject
        {
            return buildElement( child );
        }
        
        /**
         *
         * @param	child
         * @param	index
         * @return
         */
        public function addChildAt( child:DisplayObject, index:int=0 ):DisplayObject
        {
            return buildElement( child, index );
        }
        
        /**
         *
         * @param	...children
         * @return
         */
        public function removeChildren( ...children ):void
        {
            for each( var child:DisplayObject in children ) removeChild( child );
        }
        
        /**
         *
         * @param	child
         * @return
         */
        public function removeChild( child:DisplayObject ):DisplayObject
        {
            return _canvas.removeChild( child );
        }
        
        /**
         *
         * @param	index
         * @return
         */
        public function removeChildAt( index:Number ):DisplayObject
        {
            return _canvas.removeChildAt( index );
        }
        /**
         * 
         * @param name
         * @return 
         * 
         */        
        public function removeChildByName( name:String ):DisplayObject
        {
            var child:DisplayObject = _canvas.getChildByName(name);
            return child ? _canvas.removeChild( child ) : null;
        }
        /**
         * 
         * @param child
         * @param index
         * 
         */        
        public function setChildIndex(child:DisplayObject,index:int):void
        {
            _canvas.setChildIndex(child,index);
        }
        
        /**
         * 
         * @param child
         * @return 
         * 
         */		
        public function container( child:DisplayObject ):Boolean
        {
            return _canvas.contains(child);
        }
        
        /**
         *
         * @param	name
         * @return
         */
        public function getChildByName( name:String ):DisplayObject
        {
            return _canvas.getChildByName( name );
        }
        
        /**
         *
         * @param	index
         * @return
         */
        public function getChildAt( index:Number ):DisplayObject
        {
            return _canvas.getChildAt( index );
        }
        
        /**
         *
         * @return
         */
        public function get documentClass( ):DisplayObject
        {
            return _canvas.loaderInfo.content;
        }
        
        /**
         *
         * @return
         */
        public function get stageWidth( ):Number
        {
            return _canvas.stage.stageWidth;
        }
        
        /**
         *
         * @return
         */
        public function get stageHeight( ):Number
        {
            return _canvas.stage.stageHeight;
        }
        
        /**
         *
         * @return
         */
        public function get stage( ):Stage
        {
            return _canvas.stage;
        }
        
        /**
         *
         * @param	child
         * @return
         */
        public function contains( child:DisplayObject ):Boolean
        {
            return _canvas.contains(child);
        }
        
        /**
         *
         * @return
         */
        public function get stageLeft( ):Number
        {
            return (viewportRect.width - stageWidth) >> 1;
        }
        
        /**
         *
         * @return
         */
        public function get stageRight( ):Number
        {
            return viewportRect.width + Math.abs(stageLeft);
        }
        
        /**
         *
         * @return
         */
        public function get stageCenterX( ):Number
        {
            return viewportRect.width >> 1;
        }
        
        /**
         *
         * @return
         */
        public function get stageCenterY( ):Number
        {
            return viewportRect.height >> 1;
        }
        
        /**
         *
         * @return
         */
        public function get stageTop( ):Number
        {
            return 0;
        }
        
        /**
         *
         * @return
         */
        public function get stageBottom( ):Number
        {
            return stageHeight;
        }
        
        
        /**
         *
         */
        public var blocked		: Boolean = false;
        
        /**
         *
         * 
         */
        public function blockInteraction():void
        {
            blocked = true;
            _canvas.mouseEnabled = false;
            _canvas.tabEnabled = false;
        }
        
        /**
         *
         * 
         */
        public function unblockInteraction():void
        {
            blocked = false;
            _canvas.mouseEnabled = true;
            _canvas.tabEnabled = true;
        }
        
    }
}
