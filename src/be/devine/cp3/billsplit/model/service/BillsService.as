package be.devine.cp3.billsplit.model.service {

import be.devine.cp3.billsplit.factory.BillModelFactory;
import be.devine.cp3.billsplit.model.BillModel;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class BillsService extends EventDispatcher{

    private var file:File;
    private var fileStream:FileStream;
    public var bills:Vector.<BillModel>;

    public function BillsService() {
        file = File.applicationStorageDirectory.resolvePath('bills.json');
        fileStream = new FileStream();
    }

    /* Functions */
    private function readAndParseJson():Object{
        if(file.exists){
            fileStream.open(file, FileMode.READ);
            var fileContents:String = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
            fileStream.close();
            return JSON.parse(fileContents);
        }
        return null;
    }

    public function load():void{
        var bills:Vector.<BillModel> = new Vector.<BillModel>();
        var jsonObject:Object = readAndParseJson();

        if(jsonObject){
            for each(var bill:Object in jsonObject){
                bills.push(BillModelFactory.createBillModelFromObject(bill));
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

    private function deleteBillById(id):void{
        for(var i:uint = 0 ; i < bills.length ; i++){
            if(bills[i].id == id){
                bills.splice(i, 1);
            }
        }
    }

    public function writeBill(bill:BillModel):void{
        load();
        deleteBillById(bill.id);
        bills.push(bill);
        write();
    }

    public function deleteBill(bill:BillModel):void{
        load();
        deleteBillById(bill.id);
        write();
    }
}
}
