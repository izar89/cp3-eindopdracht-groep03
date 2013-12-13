/**
 * User: Stijn Heylen
 * Date: 12/12/13
 * Time: 14:51
 */
package feathers.themes.controls {

import feathers.controls.Label;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.LayoutGroupListItemRenderer;

import flash.geom.Point;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class SwipeListItemRenderer extends LayoutGroupListItemRenderer{

    private static const HELPER_POINT:Point = new Point();
    private var touchID:int = -1;

    private var container:ScrollContainer;
    private var label:Label;

    public function SwipeListItemRenderer() {}

    /* Getters & setters */

    /* Events */
    private function removedFromStageHandler(e:Event):void {
        touchID = -1;
    }

    private function touchHandler(e:TouchEvent):void {
        // reset touchID when component gets disabled while touching
        if(!this._isEnabled) {
            this.touchID = -1;
            return;
        }

        if( this.touchID >= 0 ){
            // a touch has begun, so we'll ignore all other touches.
            var touch:Touch = e.getTouch( this, null, this.touchID );

            if( !touch ) return; // this should not happen.

            if( touch.phase == TouchPhase.ENDED ){
                touch.getLocation( this.stage, HELPER_POINT );
                var isInBounds:Boolean = this.contains( this.stage.hitTest( HELPER_POINT, true ) );
                if( isInBounds ){
                    this.isSelected = true;
                }

                // the touch has ended, so now we can start watching for a new one.
                this.touchID = -1;
            }
            return;
        } else {
            // we aren't tracking another touch, so let's look for a new one.
            touch = e.getTouch( this, TouchPhase.BEGAN );
            if( !touch ) return;

            // save the touch ID so that we can track this touch's phases.
            this.touchID = touch.id;
        }
    }

    /* Functions */
    override protected function initialize():void{

        trace(this.width);

        var edit:Quad = new Quad(75,75, 0xff0000);
        addChild(edit);

        var remove:Quad = new Quad(75,75, 0xff0000);
        remove.x = 480 - 75;
        addChild(remove);

        container = new ScrollContainer();
        container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.addEventListener(TouchEvent.TOUCH, listItemTouchHandler);
        container.backgroundSkin = new Quad(480, 75, 0xf3be33);
        addChild(container);

        label = new Label();
        container.addChild(label);

        addEventListener(TouchEvent.TOUCH, touchHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    override protected function commitData():void{
        if(this._data){
            label.text = this._data.toString();
        } else {
            label.text = null;
        }
    }

    // TODO : Put both touch handlers together? and check which target is touched..
    // TODO : Make sure only edit or remove is dispatched when touch has moved (no click for selection)
    private function listItemTouchHandler(e:starling.events.TouchEvent):void {
        var currentTarget:DisplayObject = e.currentTarget as DisplayObject;
        var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
        if( touch != null ){
            switch(touch.phase){
                case TouchPhase.BEGAN:
                    break;
                case TouchPhase.MOVED:
                    currentTarget.x += (touch.globalX - touch.previousGlobalX);
                    break;
                case TouchPhase.ENDED:
                    dispatchEventWith('test', true);
                    break;
            }
        }
    }
}
}

