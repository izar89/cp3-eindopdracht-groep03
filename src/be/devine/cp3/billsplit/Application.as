package be.devine.cp3.billsplit {

import be.devine.cp3.billsplit.mobile.view.BillView;
import be.devine.cp3.billsplit.mobile.view.BillSplitView;
import be.devine.cp3.billsplit.mobile.view.BillsView;
import be.devine.cp3.billsplit.mobile.view.PeopleView;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MinimalMobileTheme;

public class Application extends ScreenNavigator{

    public static const BILLSVIEW:String = "billsView";
    public static const BILLVIEW:String = "billView";
    public static const BILLSPLITVIEW:String = "billSplitView";
    public static const ADDPERSONVIEW:String = "addPersonView";

    private var transitionManager:ScreenSlidingStackTransitionManager;

    public function Application(){
        new MinimalMobileTheme();

        addScreen(BILLSVIEW, new ScreenNavigatorItem(BillsView, {
            billSplitView: BILLSPLITVIEW,
            billView: BILLVIEW
        }));
        addScreen(BILLVIEW, new ScreenNavigatorItem(BillView, {
            billSplitView: BILLSPLITVIEW,
            billsView: BILLSVIEW
        }));
        addScreen(BILLSPLITVIEW, new ScreenNavigatorItem(BillSplitView, {
            billsView: BILLSVIEW,
            addPersonView: ADDPERSONVIEW
        }));
        addScreen(ADDPERSONVIEW, new ScreenNavigatorItem(PeopleView, {
            billSplitView: BILLSPLITVIEW
        }));

        showScreen(BILLSVIEW);

        transitionManager = new ScreenSlidingStackTransitionManager(this);
        transitionManager.duration = 0.4;
    }
}
}
