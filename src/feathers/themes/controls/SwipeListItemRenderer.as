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

    private var editImg:Image;
    private var removeImg:Image;

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

        if(this.touchID >= 0){
            // a touch has begun, so we'll ignore all other touches.
            var touch:Touch = e.getTouch( this, null, this.touchID );
            if( !touch ) return; // this should not happen.

            var currentTarget:DisplayObject = e.currentTarget as DisplayObject;
            switch(touch.phase){
                case TouchPhase.BEGAN:
                    break;
                case TouchPhase.MOVED:
                    currentTarget.x += (touch.globalX - touch.previousGlobalX);
                    if(currentTarget.x > 0){
                        editImg.alpha = (currentTarget.x / 75);
                        if(currentTarget.x >= 75){
                            editImg.x = currentTarget.x - editImg.width;
                            removeImg.alpha = 0;
                        }else {
                            editImg.x = 0;
                        }
                    } else if(currentTarget.x < 0){
                        removeImg.alpha = -(currentTarget.x / 75);
                        if(currentTarget.x <= -75){
                            removeImg.x = currentTarget.x + currentTarget.width;
                            editImg.alpha = 0;
                        }else {
                            removeImg.x = currentTarget.width - removeImg.width;
                        }
                    }
                    break;
                case TouchPhase.ENDED:

                    var positionTween:Tween = new Tween(currentTarget,.7, Transitions.EASE_OUT);
                    var alphaTween:Tween = new Tween(editImg,.7, Transitions.EASE_OUT);
                    var alphaTweenDelete:Tween = new Tween(removeImg,.7, Transitions.EASE_OUT);

                    this.isSelected = true;

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

                        // dispatch event to select
                        dispatchEventWith('select', true);
                    }

                    // the touch has ended, so now we can start watching for a new one.
                    this.touchID = -1;
                    break;
            }
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
        removeImg = new Image(removeTexture);
        removeImg.x = 480 - 75;
        removeImg.alpha = 0;
        addChild(removeImg);

        var editTexture:Texture = atlas.getTexture("edit");
        editImg = new Image(editTexture);
        editImg.x = 480 - 75;
        editImg.alpha = 0;
        addChild(editImg);

        // create container
        container = new ScrollContainer();
        container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.addEventListener(TouchEvent.TOUCH, touchHandler);
        container.backgroundSkin = new Quad(480, 75, 0xfebe33);
        addChild(container);

        var containerBorder: Quad = new Quad(480,2, 0xfea60d);
        containerBorder.y = 74;
        container.addChild(containerBorder);


        label = new Label();
        label.x = 30;
        label.y = 20;
        //label.textRendererProperties.color = 0xffffff;
        container.addChild(label);

        //addEventListener(TouchEvent.TOUCH, touchHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    override protected function commitData():void{
        if(this._data){
            label.text = this._data.toString();
        } else {
            label.text = null;
        }
    }
}
}

