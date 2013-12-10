/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:26
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.PersonsModel;

import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;

import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFormat;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextFieldAutoSize;
import starling.textures.Texture;

public class BillSplitView extends PanelScreen{

    private var personsModel:PersonsModel;

    private var backButton:Button;
    private var _addPersonButton:Button;

    private var _billButtonContainer:Sprite;
    private var _percentButton:Button;
    private var _sharedButton:Button;
    private var _ownPriceButton:Button;

    private var _billNameBox:Quad;
    private var _totalContainer:Quad;

    private var _listItem:Quad;
    private var _deleteListItem:Quad;
    private var _paidListItem:Quad;

    private var arrListItems:Array;

    public function BillSplitView() {
        addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    private function initializeHandler(e:Event):void {

        personsModel = PersonsModel.getInstance();
      //  personsModel.loadPersons();

        headerProperties.title = 'New Bill';

        backButton = new Button();
        backButton.label = '< Back';
        backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backButton];

        backButtonHandler = backButtonTriggeredHandler;

        billButtons();
        listItems();

        _totalContainer = new Quad(480, 75, 0xffffff);
        _totalContainer.x = 0;
        _totalContainer.y = 650;
        addChild(_totalContainer);

        _addPersonButton = new Button;
        _addPersonButton.label = "+";
        //_addPersonButton.addEventListener(Event.TRIGGERED, addPersonHandler);
        _addPersonButton.width = 50;
        _addPersonButton.height = 50;
        _addPersonButton.x = 420;
        _addPersonButton.y = _totalContainer.y+14;
        addChild(_addPersonButton);
    }

    /* Events */
    private function billButtons():void {

        _billButtonContainer = new Sprite();
        _billButtonContainer.y = 10;

        _percentButton = new Button();
        _percentButton.x = 10;
        _percentButton.width = 150;
        _percentButton.height = 75;
        _percentButton.label = "percent";
        _billButtonContainer.addChild(_percentButton);

        _sharedButton = new Button();
        _sharedButton.x = _percentButton.x + _percentButton.width + 5;
        _sharedButton.width = 150;
        _sharedButton.height = 75;
        _sharedButton.label = "shared";
        _billButtonContainer.addChild(_sharedButton);

        _ownPriceButton = new Button();
        _ownPriceButton.x = _sharedButton.x + _sharedButton.width + 5;
        _ownPriceButton.width = 150;
        _ownPriceButton.height = 75;
        _ownPriceButton.label = "own price";
        _billButtonContainer.addChild(_ownPriceButton);

        addChild(_billButtonContainer);
    }

    private function listItems():void {

        _billNameBox = new Quad(480, 65, 0xffffff);
        _billNameBox.x = 0;
        _billNameBox.y = _billButtonContainer.y + _billButtonContainer.height + 10;
        addChild(_billNameBox);

        // TODO: TEXTFIELD IN THEME AS LABEL

        var nativeTextField:flash.text.TextField = new flash.text.TextField();
        nativeTextField.defaultTextFormat = new TextFormat("MissionGhoticBold", 25, 0xfea60d);
        nativeTextField.embedFonts = true;
        nativeTextField.multiline = nativeTextField.wordWrap = false;
        nativeTextField.autoSize = flash.text.TextFieldAutoSize.LEFT;
        nativeTextField.width = 480;
        nativeTextField.height = 75;
        nativeTextField.text = "Bill Name";

        var bmpData:BitmapData = new BitmapData(nativeTextField.width, nativeTextField.height, true, 0);
        bmpData.draw(nativeTextField);

        var nativeTextfieldImage:Image = new Image(Texture.fromBitmapData(bmpData));
        nativeTextfieldImage.x = _billNameBox.x + 10;
        nativeTextfieldImage.y = _billNameBox.y + 15;
        addChild(nativeTextfieldImage);


        arrListItems = ["test item 1"];
        var yPos:uint = _billNameBox.y + _billNameBox.height;
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
    private function backButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(starling.events.Event.COMPLETE);
    }
}
}
