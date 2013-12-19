package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillModel;
import be.devine.cp3.billsplit.model.BillsCollection;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;
import flash.events.Event;
import flash.globalization.DateTimeFormatter;
import starling.display.DisplayObject;
import starling.events.Event;

public class BillView extends PanelScreen{

    private var billsCollection:BillsCollection;
    private var backBtn:Button;
    private var splitButtons:SplitButtons;
    private var txtNameLabel:Label;
    private var txtTotalLabel:Label;
    private var txtName:TextInput;
    private var txtTotal:TextInput;
    private var submitBtn:Button;

    public function BillView() {
        billsCollection = BillsCollection.getInstance();

        if(!billsCollection.currentBill){
            billsCollection.currentBill = createNewBillModel();
        }

        init();

        billsCollection.addEventListener(BillsCollection.CURRENTBILL_CHANGED_EVENT, currentBillChangedHandler);
        currentBillChangedHandler();

        addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* Starling events */
    private function addedToStageHandler(e:starling.events.Event):void {
        removeEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
        stage.addEventListener(starling.events.Event.RESIZE, resizeHandler);
        resize();
    }

    private function resizeHandler(e:starling.events.Event):void {
        resize();
    }

    private function backBtnTriggeredHandler(e:starling.events.Event):void {
        dispatchEventWith(Application.BILLSVIEW, false);
    }

    private function submitBtnTriggeredHandler(e:starling.events.Event):void {

        if(txtName.text.length > 0 && txtTotal.text.length){
            billsCollection.currentBill.name = txtName.text;
            billsCollection.currentBill.total = Number(txtTotal.text);
            billsCollection.writeBill();

            dispatchEventWith(Application.BILLSVIEW, false);
        }
    }

    private function currentBillChangedHandler(e:flash.events.Event = null):void {
        if(billsCollection.currentBill){
            txtName.text = billsCollection.currentBill.name;
            txtTotal.text = billsCollection.currentBill.total.toString();
        }
    }

    /* Functions */
    private function init():void{
        headerProperties.title = 'Add Bill';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(starling.events.Event.TRIGGERED, backBtnTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];
        backButtonHandler = backBtnTriggeredHandler;

        splitButtons = new SplitButtons();
        splitButtons.x = 5;
        splitButtons.y = 10;
        addChild(splitButtons);

        // Textfield Labels
        txtNameLabel = new Label();
        txtNameLabel.text = "Bill Name";
        addChild(txtNameLabel);

        txtTotalLabel = new Label();
        txtTotalLabel.text = "Total Price";
        addChild(txtTotalLabel);

        // Textfields
        txtName = new TextInput();
        txtName.maxChars = 16;
        //input.restrict = "0-9";
        addChild(txtName);

        txtTotal = new TextInput();
        txtTotal.maxChars = 16;
        txtTotal.restrict = "0-9\\,";
        addChild(txtTotal);

        // Button
        submitBtn = new Button();
        submitBtn.label = 'Add bill';
        submitBtn.addEventListener(starling.events.Event.TRIGGERED, submitBtnTriggeredHandler);
        addChild(submitBtn);
    }

    private function createNewBillModel():BillModel{
        var newBill:BillModel = new BillModel();
        var date:Date = new Date();
        var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
        dtf.setDateTimePattern("dd/MM/yyyy HH:mm:ss");
        newBill.id = date.toString();
        newBill.name = dtf.format(date);
        newBill.total = 0;
        newBill.billType = "ownprice";

        return newBill;
    }

    private function resize():void{
        txtName.setSize(stage.stageWidth, txtName.minHeight);
        txtTotal.setSize(stage.stageWidth, txtTotal.minHeight);
        submitBtn.setSize(stage.stageWidth, submitBtn.minHeight);
        txtNameLabel.y = splitButtons.y + splitButtons.height + 10;
        txtNameLabel.x = 20;
        txtName.y = txtNameLabel.y + 30;
        txtTotalLabel.y = txtName.y + txtName.height + 10;
        txtTotalLabel.x = 20;
        txtTotal.y = txtTotalLabel.y + 30;
        submitBtn.y = txtTotal.height + txtTotal.y + 50;
        submitBtn.width = 400;
        submitBtn.x = (stage.stageWidth - submitBtn.width) / 2;
    }
}
}
