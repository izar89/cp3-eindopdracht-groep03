package be.devine.cp3.billsplit {

import be.devine.cp3.billsplit.mobile.view.BillView;
import be.devine.cp3.billsplit.mobile.view.BillSplitView;
import be.devine.cp3.billsplit.mobile.view.BillsView;
import be.devine.cp3.billsplit.mobile.view.PeopleView;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MinimalMobileTheme;

import starling.events.Event;

public class Application extends ScreenNavigator{

    private static const BILLSVIEW:String = "billsView";
    private static const BILLVIEW:String = "billView";
    private static const BILLSPLITVIEW:String = "billSplitView";
    private static const ADDPERSONVIEW:String = "addPersonView";

    private var transitionManager:ScreenSlidingStackTransitionManager;

    public function Application(){
        new MinimalMobileTheme();

        addScreen(BILLSVIEW, new ScreenNavigatorItem(BillsView, {
            billSplitView: BILLSPLITVIEW,
            billView: BILLVIEW
        }));
        addScreen(BILLVIEW, new ScreenNavigatorItem(BillView, {
            complete: BILLSPLITVIEW,
            billsView: BILLSVIEW
        }));
        addScreen(BILLSPLITVIEW, new ScreenNavigatorItem(BillSplitView, {
            complete: BILLSVIEW,
            addPersonView: ADDPERSONVIEW
        }));
        addScreen(ADDPERSONVIEW, new ScreenNavigatorItem(PeopleView, {
            complete: BILLSPLITVIEW
        }));

        showScreen(BILLSVIEW);

        transitionManager = new ScreenSlidingStackTransitionManager(this);
        transitionManager.duration = 0.4;
    }
}
}
