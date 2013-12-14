package feathers.themes.controls {

import feathers.controls.Label;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.LayoutGroupListItemRenderer;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class SwipeListItemRenderer extends LayoutGroupListItemRenderer{

    [Embed(source="/../assets/images/custom.xml", mimeType="application/octet-stream")]
    public static const AtlasXml:Class;

    [Embed(source="/../assets/images/custom.png")]
    public static const AtlasTexture:Class;

    private static const HELPER_POINT:Point = new Point();
    private var touchID:int = -1;

    private var container:ScrollContainer;
    private var label:Label;

    private var edit:Image;
    private var remove:Image;

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

        // create texture atlas
        var texture:Texture = Texture.fromBitmap(new AtlasTexture());
        var xml:XML = XML(new AtlasXml());
        var atlas:TextureAtlas = new TextureAtlas(texture, xml);

        // add texture
        var removeTexture:Texture = atlas.getTexture("delete");
        remove = new Image(removeTexture);
        remove.x = 480 - 75;
        remove.alpha = 0;
        addChild(remove);

        var editTexture:Texture = atlas.getTexture("edit");
        edit = new Image(editTexture);
        edit.x = 480 - 75;
        edit.alpha = 0;
        addChild(edit);

        // create container
        container = new ScrollContainer();
        container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.addEventListener(TouchEvent.TOUCH, listItemTouchHandler);
        container.backgroundSkin = new Quad(480, 75, 0xfebe33);
        addChild(container);

        var containerBorder: Quad = new Quad(480,2, 0xfea60d);
        containerBorder.y = 74;
        container.addChild(containerBorder);


        label = new Label();
        label.x = 30;
        label.y = 20;
      //  label.textRendererProperties.color = 0xffffff;
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

                    if(currentTarget.x > 0){
                        edit.alpha = (currentTarget.x / 75);
                        if(currentTarget.x >= 75){
                            edit.x = currentTarget.x - edit.width;
                            remove.alpha = 0;
                        }else {
                            edit.x = 0;
                        }
                    } else if(currentTarget.x < 0){
                        remove.alpha = -(currentTarget.x / 75);
                        if(currentTarget.x <= -75){
                            remove.x = currentTarget.x + currentTarget.width;
                            edit.alpha = 0;
                        }else {
                            remove.x = currentTarget.width - remove.width;
                        }
                    }

                    break;
                case TouchPhase.ENDED:

                    var positionTween:Tween = new Tween(currentTarget,.7, Transitions.EASE_OUT);
                    var alphaTween:Tween = new Tween(edit,.7, Transitions.EASE_OUT);
                    var alphaTweenDelete:Tween = new Tween(remove,.7, Transitions.EASE_OUT);

                    if(currentTarget.x >= 75){
                        // swipe to edit
                        positionTween.animate("x", 480);
                        alphaTween.animate("alpha", 0);
                        alphaTweenDelete.animate("alpha",0);
                        alphaTween.animate("x", 405);

                        Starling.juggler.add(positionTween);
                        Starling.juggler.add(alphaTween);
                        Starling.juggler.add(alphaTweenDelete);

                        // dispatch event to edit
                        dispatchEventWith('edit', true);

                    } else if(currentTarget.x <= -75){
                        // swipe to delete
                        positionTween.animate("x", -480);
                        alphaTweenDelete.animate("x", 0);
                        alphaTween.animate("alpha",0);
                        alphaTweenDelete.animate("alpha", 0);

                        Starling.juggler.add(positionTween);
                        Starling.juggler.add(alphaTweenDelete);
                        Starling.juggler.add(alphaTween);

                        // dispatch event to delete
                        dispatchEventWith('delete', true);
                    } else {
                        positionTween.animate("x", 0);
                        Starling.juggler.add(positionTween);
                    }

                    break;
            }
        }
    }
}
}

