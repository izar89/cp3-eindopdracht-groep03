package be.devine.cp3.billsplit.mobile.view {
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;

import flash.display.BitmapData;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

import feathers.controls.Button;

import starling.textures.TextureAtlas;

public class SplitButtons extends Sprite {

    [Embed(source="/../assets/images/custom.png")]
    protected static const ATLAS_IMAGE:Class;

    [Embed(source="/../assets/images/custom.xml", mimeType="application/octet-stream")]
    protected static const ATLAS_XML:Class;

    private var buttonGroup:LayoutGroup;
    private var textureAtlas:TextureAtlas;

    private var ownpriceBtn:Button;
    private var sharedBtn:Button;
    private var percentBtn:Button;


    public function SplitButtons() {

        const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
        textureAtlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));

        buttonGroup = new LayoutGroup();
        addChild(buttonGroup);

        var layout:HorizontalLayout = new HorizontalLayout();
        layout.gap = 10;
        buttonGroup.layout = layout;
        buttonGroup.height = 75;

        ownpriceBtn = new Button();
        ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice"));
        ownpriceBtn.setSize(150, 75);
        buttonGroup.addChild(ownpriceBtn);

        sharedBtn = new Button();
        sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared"));
        sharedBtn.setSize(150, 75);
        buttonGroup.addChild(sharedBtn);

        percentBtn = new Button();
        percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage"));
        percentBtn.setSize(150, 75);
        buttonGroup.addChild(percentBtn);

        ownpriceBtn.addEventListener(Event.TRIGGERED, ownpriceBtnTriggeredHandler);
        sharedBtn.addEventListener(Event.TRIGGERED, sharedBtnTriggeredHandler);
        percentBtn.addEventListener(Event.TRIGGERED, percentBtnTriggeredHandler);

    }

    private function ownpriceBtnTriggeredHandler(e:Event):void {

        ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice_active"));
        sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared"));
        percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage"));

        dispatchEventWith("ownprice");

    }

    private function sharedBtnTriggeredHandler(e:Event):void {
        ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice"));
        sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared_active"));
        percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage"));

        dispatchEventWith("shared");
    }

    private function percentBtnTriggeredHandler(e:Event):void {
        ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice"));
        sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared"));
        percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage_active"));

        dispatchEventWith("percentage");
    }

}
}