package be.devine.cp3.billsplit.mobile.view {
import be.devine.cp3.billsplit.model.BillModel;
import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.model.BillsCollection;

import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;

import flash.display.BitmapData;
import flash.events.Event;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import feathers.controls.Button;
import starling.textures.TextureAtlas;

public class SplitButtons extends Sprite {

    [Embed(source="/../assets/images/custom/custom.png")]
    protected static const ATLAS_IMAGE:Class;

    [Embed(source="/../assets/images/custom/custom.xml", mimeType="application/octet-stream")]
    protected static const ATLAS_XML:Class;


    private var billsCollection:BillsCollection;

    private var buttonGroup:LayoutGroup;
    private var textureAtlas:TextureAtlas;

    private var ownpriceBtn:Button;
    private var sharedBtn:Button;
    private var percentBtn:Button;


    public function SplitButtons() {

        billsCollection = BillsCollection.getInstance();

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

        ownpriceBtn.addEventListener(starling.events.Event.TRIGGERED, ownpriceBtnTriggeredHandler);
        sharedBtn.addEventListener(starling.events.Event.TRIGGERED, sharedBtnTriggeredHandler);
        percentBtn.addEventListener(starling.events.Event.TRIGGERED, percentBtnTriggeredHandler);

        //billsCollection.currentBill.addEventListener(BillModel.BILLTYPE_CHANGED_EVENT, billTypeChangedHandler);
    }

    private function ownpriceBtnTriggeredHandler(e:starling.events.Event):void {
        billsCollection.currentBill.billType = "ownprice";
    }

    private function sharedBtnTriggeredHandler(e:starling.events.Event):void {
        billsCollection.currentBill.billType = "shared";
    }

    private function percentBtnTriggeredHandler(e:starling.events.Event):void {
        billsCollection.currentBill.billType = "percentage";
    }

    private function billTypeChangedHandler(e:flash.events.Event):void {
        setSplitBtnIcons();
    }

    public function setSplitBtnIcons():void{
        switch (billsCollection.currentBill.billType){
            case "ownprice":
                ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice_active"));
                sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared"));
                percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage"));
                break;
            case "shared":
                ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice"));
                sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared_active"));
                percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage"));
                break;
            case "percentage":
                ownpriceBtn.defaultIcon = new Image(textureAtlas.getTexture("ownprice"));
                sharedBtn.defaultIcon = new Image(textureAtlas.getTexture("shared"));
                percentBtn.defaultIcon = new Image(textureAtlas.getTexture("percentage_active"));
                break;
        }
    }

    public function setSize():void{ //TODO

    }
}
}