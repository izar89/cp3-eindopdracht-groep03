/**
 * User: Stijn Heylen
 * Date: 05/12/13
 * Time: 14:29
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.vo.BillVO;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class BillsModel extends EventDispatcher{

    private static var instance:BillsModel;

    private var file:File;
    private var fileStream:FileStream;

    private var _bills:Vector.<BillVO>;
    private var billsChanged:Boolean;
    public static const BILLS_CHANGED_EVENT:String = "billsChanged";

    /* Constructor */
    public function BillsModel(e:Enforcer) {
        if (e == null) {
            throw new Error("BillsModel is a singleton, use getInstance() instead");
        }
        file = File.applicationStorageDirectory.resolvePath('bills.json');
        fileStream = new FileStream();
//        if(!file.exists){
//            var original = File.applicationDirectory.resolvePath('bills.json');
//            original.copyTo(file, true);
//            trace('File not found');
//        }
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

    /* Functions */
    private function commitProperties():void{
        if(billsChanged){
            billsChanged = false;
        }
    }

    private function createBillVo(id:uint, name:String, created:Date, updated:Date, total:Number, paid:Boolean):BillVO{
        var billVO:BillVO = new BillVO();
        billVO.id = id;
        billVO.name = name;
        billVO.created = created;
        billVO.updated = updated;
        billVO.total = total;
        billVO.paid = paid;
        return billVO;
    }

    public function loadBills():void{
        fileStream.open(file, FileMode.READ);
        var fileContents:String = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
        fileStream.close();

        var jsonObject:Object = JSON.parse(fileContents);
        var bills:Object = jsonObject.bills;
        var billsVector:Vector.<BillVO> = new Vector.<BillVO>();

        for each(var bill:Object in bills){
            billsVector.push(createBillVo(bill.id, bill.name, bill.created, bill.updated, bill.total, bill.paid));
        }

        bills = billsVector;
    }

    private function writeBills(bills:Vector.<BillVO>):void{
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(bills));
        fileStream.close();
    }
}
}
internal class Enforcer{}
