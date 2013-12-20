package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.model.PeopleCollection;
import be.devine.cp3.billsplit.vo.PersonVO;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;

import flash.events.Event;

import starling.display.DisplayObject;
import starling.events.Event;

public class PeopleView extends PanelScreen {

    private var peopleCollection:PeopleCollection;
    private var billsCollection:BillsCollection;

    private var backBtn:Button;

    private var txtNameLabel:Label;
    private var txtPriceLabel:Label;

    private var txtName:TextInput;
    private var txtPrice:TextInput;
    private var addBtn:Button;

    public function PeopleView() {
        peopleCollection = PeopleCollection.getInstance();
        billsCollection = BillsCollection.getInstance();

        init();

        billsCollection.addEventListener(PeopleCollection.CURRENTPERSON_CHANGED_EVENT, currentPersonChangedHandler);
        currentPersonChangedHandler();

        addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* Events */
    private function addedToStageHandler(e:starling.events.Event):void {
        removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
        stage.addEventListener(starling.events.Event.RESIZE, resizeHandler);
        resize();
    }

    private function resizeHandler(e:starling.events.Event):void {
        resize();
    }

    private function backBtnTriggeredHandler(e:starling.events.Event):void {
        dispatchEventWith(Application.BILLSPLITVIEW);
    }

    private function currentPersonChangedHandler(e:flash.events.Event = null):void {
        if(peopleCollection.currentPerson){
            txtName.text = peopleCollection.currentPerson.name;
            txtPrice.text = peopleCollection.currentPerson.total.toString();
        }
    }

    private function addPersonTriggeredHandler(e:starling.events.Event):void {

        if(txtName.text.length > 0){

            if(peopleCollection.currentPerson){
                peopleCollection.currentPerson.name = txtName.text;
                peopleCollection.currentPerson.total = Number(txtPrice.text);

                peopleCollection.writePeople(billsCollection.currentBill.id);

            }else {
                var newPerson:PersonVO = new PersonVO();
                var date:Date = new Date();
                newPerson.id = date.toString();
                newPerson.name = txtName.text;
                newPerson.billId = billsCollection.currentBill.id;
                if(txtPrice.text.length == 0 ){
                    newPerson.total = parseFloat("0");
                }else {
                    newPerson.total = parseFloat(txtPrice.text);
                }
                peopleCollection.addPerson(newPerson);
                peopleCollection.writePeople(billsCollection.currentBill.id);
            }

            dispatchEventWith(Application.BILLSPLITVIEW);
        }
    }

    /* Functions */
    private function init():void{
        headerProperties.title = 'Add Person';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(starling.events.Event.TRIGGERED, backBtnTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];
        backButtonHandler = backBtnTriggeredHandler;

        // Textfield Labels
        txtNameLabel = new Label();
        txtNameLabel.text = "Name";
        addChild(txtNameLabel);

        txtPriceLabel = new Label();

        // Textfields
        txtName = new TextInput();
        txtName.maxChars = 16;
        addChild(txtName);

        switch(billsCollection.currentBill.billType){
            case "shared":
                txtPriceLabel.text = "Shared Price";
                txtPrice = new TextInput();
            break;
            case "ownprice":
                txtPriceLabel.text = "Your own Price";
                priceInput();
                break;
            case "percentage":
                txtPriceLabel.text = "Percentage";
                priceInput();
                break;
            default:
                break;
        }

        // Button
        addBtn = new Button();
        addBtn.label = 'Add Person';
        addBtn.addEventListener(starling.events.Event.TRIGGERED, addPersonTriggeredHandler);
        addChild(addBtn);
    }

    private function priceInput():void {
        addChild(txtPriceLabel);

        txtPrice = new TextInput();
        txtPrice.maxChars = 16;
        txtPrice.restrict = "0-9\\,";
        addChild(txtPrice);
    }

    private function resize():void{
        txtName.setSize(stage.stageWidth, txtName.minHeight);
        txtPrice.setSize(stage.stageWidth, txtPrice.minHeight);
        addBtn.setSize(stage.stageWidth, addBtn.minHeight);
        txtNameLabel.y = 10;
        txtNameLabel.x = 20;
        txtName.y = txtNameLabel.y + 30;
        txtPriceLabel.y = txtName.y + txtName.height + 10;
        txtPriceLabel.x = 20;
        txtPrice.y = txtPriceLabel.y + 30;
        if(billsCollection.currentBill.billType == "shared"){
            addBtn.y = txtName.height + txtName.y + 50;
        } else {
            addBtn.y = txtPrice.height + txtPrice.y + 50;
        }
        addBtn.width = 400;
        addBtn.x = (stage.stageWidth - addBtn.width) / 2;
    }
}
}