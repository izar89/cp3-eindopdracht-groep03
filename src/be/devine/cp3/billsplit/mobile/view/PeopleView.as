package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.model.PeopleCollection;
import be.devine.cp3.billsplit.vo.PersonVO;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;
import starling.display.DisplayObject;
import starling.events.Event;

public class PeopleView extends PanelScreen {

    private var personsModel:PeopleCollection;
    private var billsModel:BillsCollection;

    private var backBtn:Button;

    private var txtNameLabel:Label;
    private var txtPriceLabel:Label;

    private var txtName:TextInput;
    private var txtPrice:TextInput;
    private var addBtn:Button;

    public function PeopleView() {
        personsModel = PeopleCollection.getInstance();
        billsModel = BillsCollection.getInstance();

        init();

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* Events */
    private function addedToStageHandler(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        stage.addEventListener(Event.RESIZE, resizeHandler);
        resize();
    }

    private function resizeHandler(e:Event):void {
        resize();
    }

    private function backBtnTriggeredHandler(e:Event):void {
        dispatchEventWith(Application.BILLSPLITVIEW);
    }

    private function addPersonTriggeredHandler(e:Event):void {

        if(txtName.text.length > 0){
            var newPerson:PersonVO = new PersonVO();
            var date:Date = new Date();
            newPerson.id = date.toString();
            newPerson.name = txtName.text;
            newPerson.billId = billsModel.currentBill.id;;
            if(txtPrice.text.length == 0 ){
                newPerson.amount = parseFloat("0");
            }else {
                newPerson.amount = parseFloat(txtPrice.text);
            }
            personsModel.addPerson(newPerson);
            personsModel.writePersons(billsModel.currentBill.id);
            dispatchEventWith(Application.BILLSPLITVIEW);
        }
    }

    /* Functions */
    private function init():void{
        headerProperties.title = 'Add Person';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(Event.TRIGGERED, backBtnTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];
        backButtonHandler = backBtnTriggeredHandler;

        // Textfield Labels
        txtNameLabel = new Label();
        txtNameLabel.text = "Name";
        addChild(txtNameLabel);

        txtPriceLabel = new Label();

        switch(billsModel.currentBill.billType){
            case "shared":
                txtPriceLabel.text = "Shared Price";
                break;
            case "ownprice":
                txtPriceLabel.text = "Your own Price";
                break;
            case "percentage":
                txtPriceLabel.text = "Percentage";
                break;
            default:
                txtPriceLabel.text = "Price";
                break;
        }
        addChild(txtPriceLabel);

        // Textfields
        txtName = new TextInput();
        txtName.maxChars = 16;
        addChild(txtName);

        txtPrice = new TextInput();
        txtPrice.maxChars = 16;
        txtPrice.restrict = "0-9\\,";
        addChild(txtPrice);

        // Button
        addBtn = new Button();
        addBtn.label = 'Add Person';
        addBtn.addEventListener(Event.TRIGGERED, addPersonTriggeredHandler);
        addChild(addBtn);
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
        addBtn.y = txtPrice.height + txtPrice.y + 50;
        addBtn.width = 400;
        addBtn.x = (stage.stageWidth - addBtn.width) / 2;
    }
}
}
