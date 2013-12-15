package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.BillsCollection;
import be.devine.cp3.billsplit.model.PeopleCollection;
import be.devine.cp3.billsplit.vo.BillVO;
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

    private var personsCollection:PeopleCollection;
    private var billsCollection:BillsCollection;

    private var saveBtn:Button;
    private var addPersonBtn:Button;

    private var personsList:List;

    private var totalTxt:Label;

    public function BillSplitView() {

        personsCollection = PeopleCollection.getInstance();
        billsCollection = BillsCollection.getInstance();

        /* Header */
        headerProperties.title = 'Bill detail: ' + billsCollection.currentBill.name;

        saveBtn = new Button();
        saveBtn.label = 'Save';
        saveBtn.addEventListener(Event.TRIGGERED, saveButtonTriggeredHandler);
        headerProperties.rightItems = new <DisplayObject>[saveBtn];

        /* Footer */
        footerFactory = customFooterFactory;

        /* List */
        personsList = new List();
        personsList.itemRendererFactory = function():IListItemRenderer{
            var renderer:SwipeListItemRenderer = new SwipeListItemRenderer();
            return renderer;
        };
        personsList.addEventListener(Event.CHANGE, personsListChangeHandler);
        personsList.addEventListener('edit', editPersonHandler);
        personsList.addEventListener('delete', deletePersonHandler);
        addChild(personsList);

        personsCollection.loadPersons(billsCollection.currentBill.id);
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

    private function personsListChangeHandler(e:Event):void {
        trace(personsList.selectedItem as PersonVO); //TODO
    }

    private function saveButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(Event.COMPLETE);
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

        totalTxt = new Label();
        totalTxt.text = "Total: " + billsCollection.currentBill.total as String;
        totalTxt.x = 50;
        container.addChild(totalTxt);

        return container;
    }

    private function display():void{
        personsList.dataProvider = new ListCollection(personsCollection.persons);
    }

    private function resize():void{
        personsList.setSize(stage.stageWidth, stage.stageHeight);
    }

    private function editPersonHandler(e:Event):void {
        trace('edit');
    }

    private function deletePersonHandler(e:Event):void {
        trace('delete');

        // billsModel.deleteBill(e.currentTarget as BillVO);
        //removeChild(e.currentTarget as SwipeListItemRenderer);

        trace(personsList.numChildren);
    }

}}