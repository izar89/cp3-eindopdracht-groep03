package be.devine.cp3.billsplit {

import be.devine.cp3.billsplit.mobile.view.BillView;
import be.devine.cp3.billsplit.mobile.view.BillSplitView;
import be.devine.cp3.billsplit.mobile.view.BillsView;
import be.devine.cp3.billsplit.mobile.view.PersonView;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MinimalMobileTheme;

import starling.events.Event;

public class Application extends ScreenNavigator{

    private static const BILLSVIEW:String = "billsView";
    private static const ADDBILLVIEW:String = "addBillView";
    private static const BILLSPLITVIEW:String = "billSplitView";
    private static const ADDPERSONVIEW:String = "addPersonView";

    private var transitionManager:ScreenSlidingStackTransitionManager;

    public function Application(){
        new MinimalMobileTheme();

        addScreen(BILLSVIEW, new ScreenNavigatorItem(BillsView, {
            billSplitView: billSplitViewHandler,
            addBillView: ADDBILLVIEW
        }));
        addScreen(ADDBILLVIEW, new ScreenNavigatorItem(BillView, {
            complete: BILLSPLITVIEW,
            billsView: billsViewHandler
        }));
        addScreen(BILLSPLITVIEW, new ScreenNavigatorItem(BillSplitView, {
            complete: BILLSVIEW,
            addPersonView: addPersonsViewHandler
        }));
        addScreen(ADDPERSONVIEW, new ScreenNavigatorItem(PersonView, {
            complete: BILLSPLITVIEW
        }));

        showScreen(BILLSVIEW);

        transitionManager = new ScreenSlidingStackTransitionManager(this);
        transitionManager.duration = 0.4;
    }

    private function billSplitViewHandler(event:Event):void{
        this.showScreen(BILLSPLITVIEW);
    }

    private function billsViewHandler(event:Event):void{
        this.showScreen(BILLSVIEW);
    }

    private function addPersonsViewHandler(event:Event):void{
        this.showScreen(ADDPERSONVIEW);
    }

}
}
