package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.PeopleService;
import be.devine.cp3.billsplit.vo.BillVO;
import be.devine.cp3.billsplit.vo.PersonVO;
import flash.events.Event;
import flash.events.EventDispatcher;

public class PeopleCollection extends EventDispatcher{

    private static var instance:PeopleCollection;

    private var _persons:Vector.<PersonVO>;
    private var personsChanged:Boolean;
    public static const PERSONS_CHANGED_EVENT:String = "personsChanged";

    /* Constructor */
    public function PeopleCollection(e:Enforcer) {
        if (e == null) {
            throw new Error("PersonsModel is a singleton, use getInstance() instead");
        }
    }

    public static function getInstance():PeopleCollection {
        if (instance == null) {
            instance = new PeopleCollection(new Enforcer());
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
        var personsService:PeopleService = e.currentTarget as PeopleService;
        persons = personsService.people;
    }

    /* Functions */
    private function commitProperties():void{
        if(personsChanged){
            personsChanged = false;
        }
    }

    public function loadPersons(billId:String):void{
        var personsService:PeopleService = new PeopleService();
        personsService.addEventListener(Event.COMPLETE, loadCompleteHandler);
        personsService.load(billId);
    }

    public function addPerson(personVO:PersonVO):void{
        _persons.push(personVO);
        dispatchEvent(new Event(PeopleCollection.PERSONS_CHANGED_EVENT));
    }

    public function writePersons(billId:String):void{
        var personsService:PeopleService = new PeopleService();
        personsService.people = persons;
        personsService.write(billId);
    }
}
}
internal class Enforcer{}
