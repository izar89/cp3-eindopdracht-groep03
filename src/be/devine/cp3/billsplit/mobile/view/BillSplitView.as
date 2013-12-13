/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:26
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.PersonsModel;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import starling.display.DisplayObject;
import starling.events.Event;

public class BillSplitView extends PanelScreen{

    private var personsModel:PersonsModel;
    private var backBtn:Button;

    public function BillSplitView() {
        personsModel = PersonsModel.getInstance();

        headerProperties.title = 'Bill detail';

        backBtn = new Button();
        backBtn.label = '< Back';
        backBtn.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backBtn];

        backButtonHandler = backButtonTriggeredHandler;

        personsModel.loadPersons();
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

    private function backButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(Event.COMPLETE);
    }

    /* Functions */
    private function resize():void{
        //TODO

    }
}
}
