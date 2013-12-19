package be.devine.cp3.billsplit.model.service {

import be.devine.cp3.billsplit.factory.BillVOFactory;
import be.devine.cp3.billsplit.vo.BillVO;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class BillsService extends EventDispatcher{

    private var file:File;
    private var fileStream:FileStream;
    public var bills:Vector.<BillVO>;

    public function BillsService() {
        file = File.applicationStorageDirectory.resolvePath('bills.json');
        fileStream = new FileStream();
    }

    /* Functions */
    public function load():void{
        var bills:Vector.<BillVO> = new Vector.<BillVO>();

        if(file.exists){
            fileStream.open(file, FileMode.READ);
            var fileContents:String = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
            fileStream.close();

            var jsonObject:Object = JSON.parse(fileContents);

            for each(var bill:Object in jsonObject){
                bills.push(BillVOFactory.createBillVOFromObject(bill));
            }
        }

        this.bills = bills;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function write():void{
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(bills, null, 4));
        fileStream.close();
    }

    public function addBill(newBill:BillVO):void{
        load();
        bills.push(newBill);
        write();
    }

    public function editBill(editBill:BillVO):void{
        load();
        for(var i:uint = 0 ; i < bills.length ; i++){
            if(bills[i].id == editBill.id){
                bills.splice(i, 1);
            }
        }
        bills.push(editBill);
        write();
    }
}
}
