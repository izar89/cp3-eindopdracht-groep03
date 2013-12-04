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

public class BillsView extends PanelScreen{

    public static const BILLSPLITVIEW:String = "billsplitView";

    private var appModel:AppModel;
    private var testButton:Button;

    public function BillsView() {
        addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
    }

    private function initializeHandler(e:Event):void {
        appModel = AppModel.getInstance();

        headerProperties.title = 'Billsview';

        testButton = new Button();
        testButton.label = "billsview >";
        testButton.addEventListener(Event.TRIGGERED, testButtonTriggeredHandler);
        headerProperties.leftItems = new <DisplayObject>[testButton];
    }

    private function testButtonTriggeredHandler(e:Event):void {
        dispatchEventWith(BILLSPLITVIEW, false);
    }
}
}
