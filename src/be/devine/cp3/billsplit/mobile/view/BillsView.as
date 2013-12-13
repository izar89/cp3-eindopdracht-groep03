/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:26
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.BillsModel;
import be.devine.cp3.billsplit.vo.BillVO;

import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.themes.controls.SwipeListItemRenderer;

import starling.events.Event;

public class BillsView extends PanelScreen{

    public static const BILLSPLITVIEW:String = "billSplitView";
    public static const ADDBILLVIEW:String = "addBillView";

    private var billsModel:BillsModel;
    private var addBillBtn:Button;
    private var billsList:List;

    public function BillsView() {
        billsModel = BillsModel.getInstance();

        /* Header */
        headerProperties.title = 'BILLS';

        /* Footer */
        footerFactory = customFooterFactory;

        // List
        billsList = new List();
        billsList.itemRendererFactory = function():IListItemRenderer{
            var renderer:SwipeListItemRenderer = new SwipeListItemRenderer();
            return renderer;
        }
        billsList.addEventListener(Event.CHANGE, billsListChangeHandler);
        billsList.addEventListener('test', testHandler);
        addChild(billsList);

        billsModel.loadBills();
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
        dispatchEventWith(ADDBILLVIEW, false);
    }

    private function billsListChangeHandler(e:Event):void {
        trace(billsList.selectedItem as BillVO); //TODO
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
        billsList.dataProvider = new ListCollection(billsModel.bills);
    }

    private function resize():void{
        billsList.setSize(stage.stageWidth, stage.stageHeight);

    }


    private function testHandler(e:Event):void {
        trace('edit');
    }
}
}
