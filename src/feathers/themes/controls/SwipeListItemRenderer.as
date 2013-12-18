package feathers.themes.controls {

import feathers.controls.Label;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.LayoutGroupListItemRenderer;
import feathers.events.FeathersEventType;
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

    public static const SELECT:String = "swipeListItemRendererSelect";
    public static const EDIT:String = "swipeListItemRendererEdit";
    public static const DELETE:String = "swipeListItemRendererDelete";

    private var touchID:int = -1;

    private var container:ScrollContainer;
    private var label:Label;
    private var editImg:Image;
    private var removeImg:Image;

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
            var touch:Touch = e.getTouch( this, null, touchID );
            if(!touch){
                return;
            }

            var currentTarget:DisplayObject = e.currentTarget as DisplayObject;
            switch(touch.phase){
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

                    var containerTween:Tween = new Tween(currentTarget,.7, Transitions.EASE_OUT);
                    var editTween:Tween = new Tween(editImg,.7, Transitions.EASE_OUT);
                    editTween.onComplete = editTweenOnCompleteHandler;
                    var deleteTween:Tween = new Tween(removeImg,.7, Transitions.EASE_OUT);
                    deleteTween.onComplete = deleteTweenOnCompleteHandler;

                    this.isSelected = true;

                    if(currentTarget.x >= 75){ // EDIT

                        containerTween.animate("x", 480);
                        editTween.animate("alpha", 0);
                        editTween.animate("x", 405);
                        Starling.juggler.add(containerTween);
                        Starling.juggler.add(editTween);

                    } else if(currentTarget.x <= -75){ // DELETE

                        containerTween.animate("x", -480);
                        deleteTween.animate("x", 0);
                        deleteTween.animate("alpha", 0);
                        Starling.juggler.add(containerTween);
                        Starling.juggler.add(deleteTween);

                    } else if(currentTarget.x >= -5 && currentTarget.x <= 5){
                        // select item
                        dispatchEventWith(SELECT, true);
                    } else {
                        containerTween.animate("x", 0);
                        Starling.juggler.add(containerTween);
                    }

                    // the touch has ended, so now we can start watching for a new one.
                    _owner.removeEventListener( FeathersEventType.SCROLL_START, owner_scrollStartHandler );
                    touchID = -1;
                    break;
            }
        } else {
            // we aren't tracking another touch, so let's look for a new one.
            touch = e.getTouch( this, TouchPhase.BEGAN );
            if(!touch){
                return;
            };

            // save the touch ID so that we can track this touch's phases.
            touchID = touch.id;

            // stop list scroll
            _owner.addEventListener(FeathersEventType.SCROLL_START, owner_scrollStartHandler);
        }
    }

    protected function owner_scrollStartHandler( event:Event ):void{
        if(touchID < 0){
            return;
        }

        // no need to listen anymore. the list won't try to scroll again with this touch.
        _owner.removeEventListener( FeathersEventType.SCROLL_START, owner_scrollStartHandler );

        // no scrolling right now, please!
        _owner.stopScrolling();
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
        container.addChild(label);

        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }

    override protected function commitData():void{
        if(this._data){
            label.text = this._data.toString();
        } else {
            label.text = null;
        }
    }

    private function editTweenOnCompleteHandler(){
        dispatchEventWith(EDIT, true);
    }

    private function deleteTweenOnCompleteHandler(){
        dispatchEventWith(DELETE, true);
    }
}
}