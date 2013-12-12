/**
 * User: Stijn Heylen
 * Date: 11/12/13
 * Time: 15:39
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.BillsModel;
import be.devine.cp3.billsplit.model.PersonsModel;
import be.devine.cp3.billsplit.vo.BillVO;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.controls.TextInput;
import starling.display.DisplayObject;
import starling.events.Event;

public class AddBillView extends PanelScreen{

    private var billsModel:BillsModel;
    private var backBtn:Button;
    private var txtName:TextInput;
    private var addBtn:Button;

    public function AddBillView() {
        billsModel = BillsModel.getInstance();

        headerProperties.title = 'Add Bill';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(Event.TRIGGERED, backBtnTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];
        backButtonHandler = backBtnTriggeredHandler;

        // Textfield
        txtName = new TextInput();
        txtName.maxChars = 16;
        //input.restrict = "0-9";
        addChild(txtName);

        // Button
        addBtn = new Button();

        addBtn.label = 'Add bill';
        addBtn.addEventListener(Event.TRIGGERED, addBtnTriggeredHandler);
        addChild(addBtn);

        billsModel.loadBills();
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
        dispatchEventWith(Event.COMPLETE);
    }

    private function addBtnTriggeredHandler(e:Event):void {
        if(txtName.text.length > 0){
            var newBill:BillVO = new BillVO();
            newBill.id = 20; //TODO
            newBill.name = txtName.text;
            newBill.created = new Date();
            newBill.updated = new Date();
            newBill.total = 0; //TODO
            billsModel.addBill(newBill);
            billsModel.writeBills();
            dispatchEventWith(Event.COMPLETE);
        }
    }

    /* Functions */
    private function resize():void{
        txtName.setSize(stage.stageWidth, txtName.minHeight);
        addBtn.setSize(stage.stageWidth, addBtn.minHeight);
        addBtn.y = txtName.height;
    }
}
}
