/**
 * User: Stijn Heylen
 * Date: 28/11/13
 * Time: 14:07
 */
package be.devine.cp3.billsplit {

import be.devine.cp3.billsplit.mobile.view.BillSplitView;
import be.devine.cp3.billsplit.mobile.view.BillsView;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
import feathers.themes.MinimalMobileTheme;

import starling.events.Event;

public class Application extends ScreenNavigator{

    private static const BILLSVIEW:String = 'billsView';
    private static const BILLSPLITVIEW:String = 'billsplitView';

    private var transitionManager:ScreenSlidingStackTransitionManager;

    public function Application(){
        new MinimalMobileTheme();

        addScreen(BILLSVIEW, new ScreenNavigatorItem(BillsView, {'billsplitView': billsViewBillsplitHandler}));
        addScreen(BILLSPLITVIEW, new ScreenNavigatorItem(BillSplitView, {complete: BILLSVIEW}));

        showScreen(BILLSVIEW);

        transitionManager = new ScreenSlidingStackTransitionManager(this);
        transitionManager.duration = 0.4;
    }

    private function billsViewBillsplitHandler(event:Event):void{
        this.showScreen(BILLSPLITVIEW);
    }
}
}
