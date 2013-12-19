package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillModel;
import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.vo.BillVO;
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
    private var billModel:BillModel;

    private var backBtn:Button;
    private var splitButtons:SplitButtons;
    private var txtNameLabel:Label;
    private var txtTotalLabel:Label;
    private var txtName:TextInput;
    private var txtTotal:TextInput;
    private var addBtn:Button;

    public function BillView() {
        billsCollection = BillsCollection.getInstance();
        billModel = BillModel.getInstance();

        init();

        billModel.addEventListener(BillModel.BILL_CHANGED_EVENT, billChangedHandler);
        if(billsCollection.currentBill){
            billModel.bill = billsCollection.currentBill;
        } else {
            billModel.bill = createNewBillVO();
        }

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

    private function addBtnTriggeredHandler(e:starling.events.Event):void {

        if(txtName.text.length > 0 && txtTotal.text.length){

            billsCollection.currentBill = billModel.bill;
            billModel.bill.name = txtName.text;
            billModel.bill.total = Number(txtTotal.text);
            if(!billsCollection.currentBill){ // ADD
                billModel.addBill();
                dispatchEventWith(Application.BILLSPLITVIEW);
            } else {
                billModel.editBill();
                dispatchEventWith(Application.BILLSVIEW);
            }
        }
    }

    private function billChangedHandler(e:flash.events.Event):void {
        txtName.text = billModel.bill.name;
        txtTotal.text = billModel.bill.total.toString();
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
        addBtn = new Button();
        addBtn.label = 'Add bill';
        addBtn.addEventListener(starling.events.Event.TRIGGERED, addBtnTriggeredHandler);
        addChild(addBtn);
    }

    private function createNewBillVO():BillVO{
        var newBill:BillVO = new BillVO();
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
        addBtn.setSize(stage.stageWidth, addBtn.minHeight);
        txtNameLabel.y = splitButtons.y + splitButtons.height + 10;
        txtNameLabel.x = 20;
        txtName.y = txtNameLabel.y + 30;
        txtTotalLabel.y = txtName.y + txtName.height + 10;
        txtTotalLabel.x = 20;
        txtTotal.y = txtTotalLabel.y + 30;
        addBtn.y = txtTotal.height + txtTotal.y + 50;
        addBtn.width = 400;
        addBtn.x = (stage.stageWidth - addBtn.width) / 2;
    }


}
}
