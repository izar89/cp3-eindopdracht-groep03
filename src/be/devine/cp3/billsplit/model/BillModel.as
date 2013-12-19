/**
 * User: Stijn Heylen
 * Date: 19/12/13
 * Time: 12:35
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.BillsService;
import be.devine.cp3.billsplit.vo.BillVO;
import flash.events.Event;
import flash.events.EventDispatcher;

public class BillModel extends EventDispatcher{

    public static const BILL_CHANGED_EVENT:String = "billChanged";
    public static const CURRENTBILLTYPE_CHANGED_EVENT:String = "currentBillTypeChanged";

    private static var instance:BillModel;

    private var _bill:BillVO;
    private var billChanged:Boolean;
    private var _currentBillType:String;
    private var currentBillTypeChanged:Boolean;

    /* Constructor */
    public function BillModel(e:Enforcer) {
        if (e == null) {
            throw new Error("BillModel is a singleton, use getInstance() instead");
        }
    }

    public static function getInstance():BillModel {
        if (instance == null) {
            instance = new BillModel(new Enforcer());
        }
        return instance;
    }

    /* Getters & setters */
    [Bindable(event="billChanged")]
    public function get bill():BillVO {
        return _bill;
    }

    public function set bill(value:BillVO):void {
        if (_bill == value) return;
        billChanged = true;
        _bill = value;
        commitProperties();
        dispatchEvent(new Event(BILL_CHANGED_EVENT));
    }

    [Bindable(event="currentBillTypeChanged")]
    public function get currentBillType():String {
        return _currentBillType;
    }

    public function set currentBillType(value:String):void {
        if (_currentBillType == value) return;
        currentBillTypeChanged = true;
        _currentBillType = value;
        commitProperties();
        dispatchEvent(new Event(CURRENTBILLTYPE_CHANGED_EVENT));
    }

    // Functions
    private function commitProperties():void{
        if(billChanged){
            billChanged = false;
            currentBillType = bill.billType;
        }
        if(currentBillTypeChanged){
            currentBillTypeChanged = false;
            bill.billType = currentBillType;
        }
    }

    public function addBill():void{
        var billService:BillsService = new BillsService();
        billService.addBill(bill);
    }

    public function editBill():void{
        var billService:BillsService = new BillsService();
        billService.editBill(bill);
    }
}
}
internal class Enforcer{}