package be.devine.cp3.billsplit.mobile.view {


import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillModel;
import be.devine.cp3.billsplit.model.BillsCollection;
import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.themes.controls.SwipeListItemRenderer;

import starling.events.Event;

public class BillsView extends PanelScreen{

    private var billsCollection:BillsCollection;
    private var addBillBtn:Button;
    private var billsList:List;

    public function BillsView() {
        billsCollection = BillsCollection.getInstance();

        /* Header */
        headerProperties.title = 'Bills';

        /* Footer */
        footerFactory = customFooterFactory;

        /* Body */
        billsList = new List();
        billsList.itemRendererFactory = function():IListItemRenderer{
            var renderer:SwipeListItemRenderer = new SwipeListItemRenderer();
            return renderer;
        };
        billsList.addEventListener(SwipeListItemRenderer.SELECT, selectBillHandler);
        billsList.addEventListener(SwipeListItemRenderer.EDIT, editBillHandler);
        billsList.addEventListener(SwipeListItemRenderer.DELETE, deleteBillHandler);
        addChild(billsList);

        billsCollection.loadBills();
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        display();
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

    private function addBillBtnTriggeredHandler(e:Event):void {
        billsCollection.currentBill = null;
        dispatchEventWith(Application.BILLVIEW, false);
    }

    private function selectBillHandler(e:Event):void {
        billsCollection.currentBill = billsList.selectedItem as BillModel;
        dispatchEventWith(Application.BILLSPLITVIEW, false);
    }

    private function editBillHandler(e:Event):void {
        billsCollection.currentBill = billsList.selectedItem as BillModel;
        dispatchEventWith(Application.BILLVIEW, false);
    }

    private function deleteBillHandler(e:Event):void {
        billsCollection.currentBill = billsList.selectedItem as BillModel;
        billsCollection.deleteCurrentBill();
        display();
    }

    /* Functions */
    private function customFooterFactory():ScrollContainer{
        var container:ScrollContainer = new ScrollContainer();
        container.nameList.add( ScrollContainer.ALTERNATE_NAME_TOOLBAR );
        container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

        addBillBtn = new Button;
        addBillBtn.label = "Add Bill";
        addBillBtn.addEventListener(Event.TRIGGERED, addBillBtnTriggeredHandler);
        container.addChild(addBillBtn);

        return container;
    }

    private function display():void{
        billsList.dataProvider = new ListCollection(billsCollection.bills);
    }

    private function resize():void{
        billsList.setSize(stage.stageWidth, stage.stageHeight);
    }
}
}
