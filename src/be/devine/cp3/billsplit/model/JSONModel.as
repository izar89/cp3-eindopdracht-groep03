/**
 * User: Stijn Heylen
 * Date: 02/12/13
 * Time: 18:31
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.vo.BillVO;
import be.devine.cp3.billsplit.vo.PersonVO;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class JSONModel extends EventDispatcher{

    private static var instance:JSONModel;

    private var file:File;
    private var fileStream:FileStream;
    private var jsonObject:Object;

    public function JSONModel(e:Enforcer) {
        if (e == null) {
            throw new Error("JSONModel is a singleton, use getInstance() instead");
        }

        file = File.applicationStorageDirectory.resolvePath('billsplit.json');
        fileStream = new FileStream();
        if(file.exists){
            loadJSON();
        } else {
//            var original = File.applicationStorageDirectory.resolvePath('billsplit.json');
//            original.copyTo(file, true);
//            loadJSON();
        }
    }

    public static function getInstance():JSONModel {
        if (instance == null) {
            instance = new JSONModel(new Enforcer());
        }
        return instance;
    }

    private function loadJSON():void{
        fileStream.open(file, FileMode.READ);
        var fileContents:String;
        fileContents = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
        fileStream.close();
        jsonObject = JSON.parse(fileContents);
        trace(jsonObject);
    }

    /* Bills */
    public function getBills(id:uint):Vector.<BillVO>{
        return new Vector.<BillVO>(); //TODO
    }

    public function addBill(billVo:BillVO):BillVO{
        return new BillVO(); //TODO
    }

    public function updateBill(billVo:BillVO):void{
        //TODO
    }

    public function deleteBill(billVo:BillVO):void{
        //TODO
    }

    /* Persons */
    public function getPersons(billId:uint):Vector.<PersonVO>{
        return new Vector.<PersonVO>(); //TODO
    }

    public function addPerson(personVo:PersonVO):PersonVO{
        return new PersonVO();//TODO
    }

    public function updatePerson(personVO:PersonVO):void{
        //TODO
    }

    public function deletePerson(personVO:PersonVO):void{
        //TODO
    }

    public function write():void{
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(jsonObject));
        fileStream.close();
    }
}
}
internal class Enforcer{}
