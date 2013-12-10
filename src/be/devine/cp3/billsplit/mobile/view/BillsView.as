/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:26
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.BillsModel;

import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;

import flash.display.BitmapData;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

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

public class BillsView extends PanelScreen{

    public static const BILLSPLITVIEW:String = "billsplitView";

    private var billsModel:BillsModel;

    private var _addBillButton:Button;
    private var _listItem:Quad;
    private var _deleteListItem:Quad;
    private var _paidListItem:Quad;

    private var arrListItems:Array;

    public function BillsView() {
        addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    private function initializeHandler(e:Event):void {
        billsModel = BillsModel.getInstance();
//        billsModel.loadBills();

        headerProperties.title = 'BILL SPLIT';

        _addBillButton = new Button;
        _addBillButton.label = "add Bill";
        _addBillButton.addEventListener(Event.TRIGGERED,  billSplitHandler);
        _addBillButton.x = 385;
        _addBillButton.y = 670;
        addChild(_addBillButton);

        listItems();
    }

    /* Events */
    private function listItems():void {

        arrListItems = ["test item 1", " test item 2", "test item 3", "test item 4"];
        var yPos:uint = 0;
        var listColor:Array = ["0xfebe33","0xfea60d"];

        var color:uint = listColor[0];

        for(var i:uint = 0; i < arrListItems.length; i++){

            // TODO: CHANGE QUADS TO ICONS

            _deleteListItem = new Quad(75,75, 0xf37121);
            _deleteListItem.x = 480 - _deleteListItem.width;
            _deleteListItem.y = yPos;
            _deleteListItem.alpha = 0;
            addChild(_deleteListItem);

            _paidListItem = new Quad(75,75, 0x8bc53f);
            _paidListItem.x = 0;
            _paidListItem.y = yPos;
            _paidListItem.alpha = 0;
            addChild(_paidListItem);

            _listItem = new Quad(480,75,color);
            _listItem.x = 0;
            _listItem.y = yPos;
            _listItem.addEventListener(TouchEvent.TOUCH, listItemTouchHandler);
            addChild(_listItem);


            // TODO: TEXTFIELD IN THEME AS LABEL

            var nativeTextField:flash.text.TextField = new flash.text.TextField();
            nativeTextField.defaultTextFormat = new TextFormat("MissionGhoticBold", 25, 0xffffff);
            nativeTextField.embedFonts = true;
            nativeTextField.multiline = nativeTextField.wordWrap = false;
            nativeTextField.autoSize = TextFieldAutoSize.LEFT;
            nativeTextField.width = 480;
            nativeTextField.height = 75;
            nativeTextField.text = "Bill #" + (i+1);

            var bmpData:BitmapData = new BitmapData(nativeTextField.width, nativeTextField.height, true, 0);
            bmpData.draw(nativeTextField);

            var nativeTextfieldImage:Image = new Image(Texture.fromBitmapData(bmpData));
            nativeTextfieldImage.x = 20;
            nativeTextfieldImage.y = _listItem.y + 20 ;
            addChild(nativeTextfieldImage);



            // TODO: ADD LABEL

            yPos += _listItem.height;

            if(color == listColor[0]){
                color = listColor[1];
            }else {
                color = listColor[0];
            }
        }

    }

    private function listItemTouchHandler(event:TouchEvent):void {

        var currentTarget:DisplayObject = event.currentTarget as DisplayObject;

        var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
        if( touch != null ){

            switch(touch.phase){
                case TouchPhase.BEGAN:
                    break;
                case TouchPhase.MOVED:

                    currentTarget.x = (touch.globalX/8)-30;

                    // TODO: DELETE/PAID ICONS FROM CURRENT TARGET
                    if(currentTarget.x > 0){
                        _paidListItem.alpha = (currentTarget.x / 75);
                        if(currentTarget.x >= 75){
                            _paidListItem.x = currentTarget.x - _paidListItem.width;
                        }else {
                            _paidListItem.x = 0;
                        }
                    } else if(currentTarget.x < 0){
                        _deleteListItem.alpha = -(currentTarget.x / 75);
                        if(currentTarget.x <= -75){
                            _deleteListItem.x = currentTarget.x + currentTarget.width;
                        }else {
                            _deleteListItem.x = currentTarget.width - _deleteListItem.width;
                        }
                    }

                    break;
                case TouchPhase.ENDED:

                    var positionTween:Tween = new Tween(currentTarget,.4, Transitions.EASE_OUT);

                    if(currentTarget.x >= 75){
                        trace("paid");
                        positionTween.animate("x", 480);
                        _paidListItem.x = 0;
                        _deleteListItem.x = _listItem.width - _deleteListItem.width;
                        Starling.juggler.add(positionTween);
                        // TODO: add to paid array + remove list item
                    } else if(currentTarget.x <= -75){
                        trace("delete");
                        positionTween.animate("x", -480);
                        _paidListItem.x = 0;
                        _deleteListItem.x = _listItem.width - _deleteListItem.width;
                        Starling.juggler.add(positionTween);
                        // TODO: delete from array + remove list item
                    } else {
                        positionTween.animate("x", 0);
                        Starling.juggler.add(positionTween);
                    }

                    // TODO: redraw list items

                    break;
            }
        }

    }


    /* Starling events */
    private function billSplitHandler(e:Event):void {
        dispatchEventWith(BILLSPLITVIEW, false);
    }

}
}
