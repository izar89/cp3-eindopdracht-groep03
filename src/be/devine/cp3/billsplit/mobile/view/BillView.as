package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.vo.BillVO;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;
import starling.display.DisplayObject;
import starling.events.Event;

public class BillView extends PanelScreen{

    public static const BILLSVIEW:String = "billsView";

    private var billsCollection:BillsCollection;
    private var backBtn:Button;

    private var splitButtons:SplitButtons;

    private var txtNameLabel:Label;
    private var txtTotalLabel:Label;

    private var txtName:TextInput;
    private var txtTotal:TextInput;
    private var addBtn:Button;

    private var billType:String;

    public function BillView() {
        billsCollection = BillsCollection.getInstance();

        headerProperties.title = 'Add Bill';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(Event.TRIGGERED, backBtnTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];
        backButtonHandler = backBtnTriggeredHandler;

        splitButtons = new SplitButtons();
        splitButtons.x = 5;
        splitButtons.y = 10;
        splitButtons.addEventListener("ownprice", ownpriceBillHandler);
        splitButtons.addEventListener("shared", sharedBillHandler);
        splitButtons.addEventListener("percentage", percentageBillHandler);
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
        addBtn.addEventListener(Event.TRIGGERED, addBtnTriggeredHandler);
        addChild(addBtn);

        billsCollection.loadBills();
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    /* Starling events */
    private function addedToStageHandler(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        stage.addEventListener(Event.RESIZE, resizeHandler);
        resize();
    }

    private function resizeHandler(e:Event):void {
        resize();
    }

    private function backBtnTriggeredHandler(e:Event):void {
        dispatchEventWith(BILLSVIEW, false);
    }

    private function ownpriceBillHandler(e:Event):void {
        billType = "ownprice";
    }
    private function sharedBillHandler(e:Event):void {
        billType = "shared";
    }
    private function percentageBillHandler(e:Event):void {
        billType = "percentage";
    }

    private function addBtnTriggeredHandler(e:Event):void {

        if(txtName.text.length > 0){
            var newBill:BillVO = new BillVO();
            var date:Date = new Date();
            newBill.id = date.toString();
            newBill.name = txtName.text;
            newBill.created = date;
            newBill.updated = date;
            if(txtTotal.text.length == 0){
                newBill.total = parseFloat("0");
            }else {
                newBill.total = parseFloat(txtTotal.text);
            }
            if(billType == ""){
                newBill.billType = billType;
            }else {
                newBill.billType = "ownprice"
            }
            billsCollection.addBill(newBill);
            billsCollection.writeBills();

            // TODO: ADD BILL ID TO NEXT VIEW
            var billID:String = newBill.id;
            billsCollection.currentBill =  newBill;
            dispatchEventWith(Event.COMPLETE);

        }
    }

    /* Functions */
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
