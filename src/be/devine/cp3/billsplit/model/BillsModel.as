/**
 * User: Stijn Heylen
 * Date: 05/12/13
 * Time: 14:29
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.BillsService;
import be.devine.cp3.billsplit.vo.BillVO;
import flash.events.Event;
import flash.events.EventDispatcher;

public class BillsModel extends EventDispatcher{

    private static var instance:BillsModel;

    private var _bills:Vector.<BillVO>;
    private var billsChanged:Boolean;
    public static const BILLS_CHANGED_EVENT:String = "billsChanged";

    /* Constructor */
    public function BillsModel(e:Enforcer) {
        if (e == null) {
            throw new Error("BillsModel is a singleton, use getInstance() instead");
        }
    }

    public static function getInstance():BillsModel {
        if (instance == null) {
            instance = new BillsModel(new Enforcer());
        }
        return instance;
    }

    /* Getters & setters */
    [Bindable(event="billsChanged")]
    public function get bills():Vector.<BillVO> {
        return _bills;
    }
    public function set bills(value:Vector.<BillVO>):void {
        if (_bills == value) return;
        billsChanged = true;
        _bills = value;
        commitProperties();
        dispatchEvent(new Event(BILLS_CHANGED_EVENT));
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
    }

    public function loadBills():void{
        var billService:BillsService = new BillsService();
        billService.addEventListener(Event.COMPLETE, loadCompleteHandler);
        billService.load();
    }

    public function writeBills():void{
        var billService:BillsService = new BillsService();
        billService.bills = bills;
        billService.write();
    }

    public function addBill(billVO:BillVO):void{
        _bills.push(billVO);
        dispatchEvent(new Event(BillsModel.BILLS_CHANGED_EVENT));
    }

    public function deleteBill(billVO:BillVO):void{
        var i:int = bills.indexOf(billVO);
        bills.splice(i, 1);
    }

    public function updateBill(billVO:BillVO):void{
        var i:int = bills.indexOf(billVO);
        bills[i] = billVO;
    }
}
}
internal class Enforcer{}
