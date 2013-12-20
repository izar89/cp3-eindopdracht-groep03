package be.devine.cp3.billsplit.model.service {
import be.devine.cp3.billsplit.factory.PersonVOFactory;
import be.devine.cp3.billsplit.vo.PersonVO;

import flash.events.Event;

import flash.events.EventDispatcher;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class PeopleService extends EventDispatcher{

    private var file:File;
    private var fileStream:FileStream;
    public var people:Vector.<PersonVO>;

    public function PeopleService() {
        file = File.applicationStorageDirectory.resolvePath('people.json');
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

    public function load(billId:String):void{
        var people:Vector.<PersonVO> = new Vector.<PersonVO>();
        var jsonObject:Object = readAndParseJson();

        if(jsonObject){
            for each(var person:Object in jsonObject){
                if(person.billId == billId){
                    people.push(PersonVOFactory.createPersonVOFromObject(person));
                }
            }
        }

        this.people = people;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function deletePersonById(id:String):void{
        for(var i:uint = 0 ; i < people.length ; i++){
            if(people[i].id == id){
                people.splice(i, 1);
            }
        }
    }

    public function deletePersonsByBillId(billId:String):void{
        write(billId);
    }

    public function deletePerson(personID:String, billID:String):void{
        load(billID);
        deletePersonById(personID);
        write(billID);
    }

    public function write(billId:String):void{
        var jsonObject:Object = readAndParseJson();

        if(jsonObject){
            //Add all people with different billId before writing
            for each(var person:Object in jsonObject){
                if(person.billId != billId){
                    this.people.push(PersonVOFactory.createPersonVOFromObject(person));
                }
            }
        }

        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(people, null, 4));
        fileStream.close();
    }
}
}
