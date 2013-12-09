/**
 * User: Stijn Heylen
 * Date: 05/12/13
 * Time: 14:30
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.vo.PersonVO;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class PersonsModel extends EventDispatcher{

    private static var instance:PersonsModel;

    private var file:File;
    private var fileStream:FileStream;

    private var _persons:Vector.<PersonVO>;
    private var personsChanged:Boolean;
    public static const PERSONS_CHANGED_EVENT:String = "personsChanged";

    /* Constructor */
    public function PersonsModel(e:Enforcer) {
        if (e == null) {
            throw new Error("PersonsModel is a singleton, use getInstance() instead");
        }
        file = File.applicationStorageDirectory.resolvePath('persons.json');
        fileStream = new FileStream();
    }

    public static function getInstance():PersonsModel {
        if (instance == null) {
            instance = new PersonsModel(new Enforcer());
        }
        return instance;
    }

    /* Getters & setters */
    [Bindable(event="personsChanged")]
    public function get persons():Vector.<PersonVO> {
        return _persons;
    }
    public function set persons(value:Vector.<PersonVO>):void {
        if (_persons == value) return;
        personsChanged = true;
        _persons = value;
        commitProperties();
        dispatchEvent(new Event(PERSONS_CHANGED_EVENT));
    }

    /* Functions */
    private function commitProperties():void{
        if(personsChanged){
            personsChanged = false;
        }
    }

    private function createPersonVo(id:uint, billId:uint, name:String, amount:Number, paid:Boolean):PersonVO{
        var personVO:PersonVO = new PersonVO();
        personVO.id = id;
        personVO.billId = billId;
        personVO.name = name;
        personVO.amount = amount;
        personVO.paid = paid;
        return personVO;
    }

    public function loadPersons():void{
        fileStream.open(file, FileMode.READ);
        var fileContents:String = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
        fileStream.close();

        var jsonObject:Object = JSON.parse(fileContents);
        var persons:Object = jsonObject.persons;
        var personsVector:Vector.<PersonVO> = new Vector.<PersonVO>();

        for each(var person:Object in persons){
            personsVector.push(createPersonVo(person.id, person.billId, person.name, person.amount, person.paid));
        }

        persons = personsVector;
    }

    private function writePersons(persons:Vector.<PersonVO>):void{
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(persons));
        fileStream.close();
    }
}
}
internal class Enforcer{}
