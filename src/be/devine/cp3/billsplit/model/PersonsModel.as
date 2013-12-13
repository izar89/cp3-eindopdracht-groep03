/**
 * User: Stijn Heylen
 * Date: 05/12/13
 * Time: 14:30
 */
package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.PersonsService;
import be.devine.cp3.billsplit.vo.BillVO;
import be.devine.cp3.billsplit.vo.PersonVO;
import flash.events.Event;
import flash.events.EventDispatcher;

public class PersonsModel extends EventDispatcher{

    private static var instance:PersonsModel;

    private var _persons:Vector.<PersonVO>;
    private var personsChanged:Boolean;
    public static const PERSONS_CHANGED_EVENT:String = "personsChanged";

    /* Constructor */
    public function PersonsModel(e:Enforcer) {
        if (e == null) {
            throw new Error("PersonsModel is a singleton, use getInstance() instead");
        }
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

    /* Events */
    private function loadCompleteHandler(e:Event):void {
        var personsService:PersonsService = e.currentTarget as PersonsService;
        persons = personsService.persons;
    }

    /* Functions */
    private function commitProperties():void{
        if(personsChanged){
            personsChanged = false;
        }
    }

    public function loadPersons():void{
        var personsService:PersonsService = new PersonsService();
        personsService.addEventListener(Event.COMPLETE, loadCompleteHandler);
        personsService.load();
    }

    private function writePersons():void{
        var personsService:PersonsService = new PersonsService();
        personsService.persons = persons;
        personsService.write();
    }
}
}
internal class Enforcer{}
