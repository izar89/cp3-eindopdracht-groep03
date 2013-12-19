package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.BillsService;
import be.devine.cp3.billsplit.model.service.PeopleService;

import flash.events.Event;
import flash.events.EventDispatcher;

public class BillsCollection extends EventDispatcher{

    public static const BILLS_CHANGED_EVENT:String = "billsChanged";
    public static const CURRENTBILL_CHANGED_EVENT:String = "currentBillChanged";

    private static var instance:BillsCollection;

    private var _bills:Vector.<BillModel>;
    private var billsChanged:Boolean;
    private var _currentBill:BillModel;
    private var currentBillChanged:Boolean;

    /* Constructor */
    public function BillsCollection(e:Enforcer) {
        if (e == null) {
            throw new Error("BillsCollection is a singleton, use getInstance() instead");
        }
    }

    public static function getInstance():BillsCollection {
        if (instance == null) {
            instance = new BillsCollection(new Enforcer());
        }
        return instance;
    }

    /* Getters & setters */
    [Bindable(event="billsChanged")]
    public function get bills():Vector.<BillModel> {
        return _bills;
    }
    public function set bills(value:Vector.<BillModel>):void {
        if (_bills == value) return;
        billsChanged = true;
        _bills = value;
        commitProperties();
        dispatchEvent(new Event(BILLS_CHANGED_EVENT));
    }

    [Bindable(event="currentBillChanged")]
    public function get currentBill():BillModel {
        return _currentBill;
    }

    public function set currentBill(value:BillModel):void {
        if (_currentBill == value) return;
        currentBillChanged = true;
        _currentBill = value;
        commitProperties();
        dispatchEvent(new Event(CURRENTBILL_CHANGED_EVENT));
    }

    /* Events */
    private function loadCompleteHandler(e:Event):void {
        var billService:BillsService = e.currentTarget as BillsService;
        bills = billService.bills;
    }

    /* Functions */
    private function commitProperties():void{
        if(billsChanged){
            billsChanged = false;
        }
        if(currentBillChanged){
            currentBillChanged = false;
        }
    }

    public function loadBills():void{
        var billService:BillsService = new BillsService();
        billService.addEventListener(Event.COMPLETE, loadCompleteHandler);
        billService.load();
    }

    public function writeBill():void{
        var billService:BillsService = new BillsService();
        billService.writeBill(currentBill);
    }

    public function deleteCurrentBill():void{
        var billService:BillsService = new BillsService();
        var peopleService:PeopleService = new PeopleService();
        var i:int = bills.indexOf(currentBill);

        // delete from list
        bills.splice(i, 1);

        // delete bill from json
        billService.deleteBill(currentBill);

        //TODO: delete people from bill
    }
}
}
internal class Enforcer{}
