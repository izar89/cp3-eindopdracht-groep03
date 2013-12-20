package be.devine.cp3.billsplit {

import be.devine.cp3.billsplit.mobile.view.BillView;
import be.devine.cp3.billsplit.mobile.view.BillSplitView;
import be.devine.cp3.billsplit.mobile.view.BillsView;
import be.devine.cp3.billsplit.mobile.view.PersonView;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MinimalMobileTheme;

public class Application extends ScreenNavigator{

    public static const BILLSVIEW:String = "billsView";
    public static const BILLVIEW:String = "billView";
    public static const BILLSPLITVIEW:String = "billSplitView";
    public static const PERSONVIEW:String = "personView";

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
            personView: PERSONVIEW
        }));
        addScreen(PERSONVIEW, new ScreenNavigatorItem(PersonView, {
            billSplitView: BILLSPLITVIEW
        }));

        showScreen(BILLSVIEW);

        transitionManager = new ScreenSlidingStackTransitionManager(this);
        transitionManager.duration = 0.4;
    }
}
}
