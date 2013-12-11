/**
 * User: Stijn Heylen
 * Date: 10/12/13
 * Time: 20:54
 */
package be.devine.cp3.billsplit.model.service {
import be.devine.cp3.billsplit.factory.PersonVOFactory;
import be.devine.cp3.billsplit.vo.PersonVO;

import flash.events.Event;

import flash.events.EventDispatcher;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class PersonsService extends EventDispatcher{

    private var file:File;
    private var fileStream:FileStream;
    public var persons:Vector.<PersonVO>;

    public function PersonsService() {
        file = File.applicationStorageDirectory.resolvePath('persons.json');
        fileStream = new FileStream();
    }

    /* Functions */
    public function load():void{
        var persons:Vector.<PersonVO> = new Vector.<PersonVO>();

        if(file.exists){
            fileStream.open(file, FileMode.READ);
            var fileContents:String = fileStream.readMultiByte(fileStream.bytesAvailable, 'utf-8');
            fileStream.close();

            var jsonObject:Object = JSON.parse(fileContents);

            for each(var person:Object in jsonObject){
                persons.push(PersonVOFactory.createPersonVOFromObject(person));
            }
        }

        this.persons = persons;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function write():void{
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(JSON.stringify(persons, null, 4));
        fileStream.close();
    }
}
}
