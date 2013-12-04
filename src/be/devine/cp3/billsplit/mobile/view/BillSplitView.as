/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:26
 */
package be.devine.cp3.billsplit.mobile.view {

import be.devine.cp3.billsplit.model.AppModel;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.events.FeathersEventType;
import starling.display.DisplayObject;
import starling.events.Event;

public class BillSplitView extends PanelScreen{

    private var appModel:AppModel;
    private var backButton:Button;

    public function BillSplitView() {
        addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    private function initializeHandler(e:Event):void {
        appModel = AppModel.getInstance();

        headerProperties.title = 'Billsplitview';

        backButton = new Button();
        backButton.label = '< Back';
        backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[backButton];

        backButtonHandler = backButtonTriggeredHandler;
    }

    private function backButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(starling.events.Event.COMPLETE);
    }
}
}
