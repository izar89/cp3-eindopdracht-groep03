package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.Application;
import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.model.PeopleCollection;
import be.devine.cp3.billsplit.model.service.SplitService;
import be.devine.cp3.billsplit.vo.PersonVO;

import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.List;
import feathers.controls.PanelScreen;
import feathers.controls.ScrollContainer;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.ListCollection;
import feathers.themes.controls.SwipeListItemRenderer;

import starling.display.DisplayObject;
import starling.events.Event;

public class BillSplitView extends PanelScreen{

    public static const ADDPERSONVIEW:String = "addPersonView";

    private var peopleCollection:PeopleCollection;
    private var billsCollection:BillsCollection;

    private var arrPeople:Array;

    private var peopleList:List;
    private var saveBtn:Button;
    private var addPersonBtn:Button;
    private var totalTxt:Label;
    private var billTotal:Number;
    private var rest:Number;

    public function BillSplitView() {
        peopleCollection = PeopleCollection.getInstance();
        billsCollection = BillsCollection.getInstance();

        /* Header */
        headerProperties.title = billsCollection.currentBill.name;

        splitBill();

        saveBtn = new Button();
        saveBtn.label = 'Save';
        saveBtn.addEventListener(Event.TRIGGERED, saveButtonTriggeredHandler);
        headerProperties.rightItems = new <DisplayObject>[saveBtn];

        /* Footer */
        footerFactory = customFooterFactory;

        /* List */
        peopleList = new List();
        peopleList.itemRendererFactory = function():IListItemRenderer{
            var renderer:SwipeListItemRenderer = new SwipeListItemRenderer();
            return renderer;
        };
        peopleList.addEventListener(Event.CHANGE, peopleListChangeHandler);
        addChild(peopleList);

        peopleCollection.loadPeople(billsCollection.currentBill.id);
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

    private function addPersonBtnTriggeredHandler(e:Event):void {
        dispatchEventWith(ADDPERSONVIEW, false);
    }

    private function peopleListChangeHandler(e:Event):void {
        trace(peopleList.selectedItem as PersonVO); //TODO
    }

    private function saveButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(Application.BILLSVIEW);
    }

    /* Functions */
    private function customFooterFactory():ScrollContainer{
        var container:ScrollContainer = new ScrollContainer();
        container.nameList.add( ScrollContainer.ALTERNATE_NAME_TOOLBAR );
        container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
        container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;

        addPersonBtn = new Button;
        addPersonBtn.label = "Add Person";
        addPersonBtn.addEventListener(Event.TRIGGERED, addPersonBtnTriggeredHandler);
        container.addChild(addPersonBtn);

        billTotal = billsCollection.currentBill.total;
        totalTxt = new Label();
        trace("[BillSplitView] rest: " + rest);
        totalTxt.text = "Total: " + billTotal + " / Rest: " + rest;
        container.addChild(totalTxt);

        return container;
    }

    private function pushPeople():void {
        arrPeople = [];

    }

    private function  splitBill():void {
        // arr with all people
        var arrPeople:Array = ["name 1", "name 2", "name 3"];
        // arr with all people.amount
        var arrPrices:Array = [2, 3, 5, 6, 4];
        // arr with all people.amount (percent)
        var arrPercentages:Array = [30,20,40];

        var billtype:String = "shared";

        switch(billtype){

            case "shared":
                rest = SplitService.shared(billTotal,arrPeople);
                break;
            case "ownprice":
                rest = SplitService.shared(billTotal, arrPrices);
                break;
            case "percentage":
                rest = SplitService.percentage(billTotal, arrPercentages);
                break;
            default:
                rest = SplitService.shared(billTotal,arrPeople);
                break;
        }
    }


    private function display():void{
        peopleList.dataProvider = new ListCollection(peopleCollection.people);
    }

    private function resize():void{
        peopleList.setSize(stage.stageWidth, stage.stageHeight);
    }

}}