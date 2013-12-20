package be.devine.cp3.billsplit.model {

import be.devine.cp3.billsplit.model.service.PeopleService;
import be.devine.cp3.billsplit.vo.PersonVO;
import flash.events.Event;
import flash.events.EventDispatcher;

public class PeopleCollection extends EventDispatcher{

    private static var instance:PeopleCollection;

    public static const PEOPLE_CHANGED_EVENT:String = "peopleChanged";
    public static const CURRENTPERSON_CHANGED_EVENT:String = "currentPersonChanged";

    private var _people:Vector.<PersonVO>;
    private var peopleChanged:Boolean;
    private var _currentPerson:PersonVO;
    private var currentPersonChanged:Boolean;

    /* Constructor */
    public function PeopleCollection(e:Enforcer) {
        if (e == null) {
            throw new Error("PeopleCollection is a singleton, use getInstance() instead");
        }
    }

    public static function getInstance():PeopleCollection {
        if (instance == null) {
            instance = new PeopleCollection(new Enforcer());
        }
        return instance;
    }

    /* Getters & setters */
    [Bindable(event="peopleChanged")]
    public function get people():Vector.<PersonVO> {
        return _people;
    }
    public function set people(value:Vector.<PersonVO>):void {
        if (_people == value) return;
        peopleChanged = true;
        _people = value;
        commitProperties();
        dispatchEvent(new Event(PEOPLE_CHANGED_EVENT));
    }

    [Bindable(event="currentPersonChanged")]
    public function get currentPerson():PersonVO {
        return _currentPerson;
    }

    public function set currentPerson(value:PersonVO):void {
        if (_currentPerson == value) return;
        currentPersonChanged = true;
        _currentPerson = value;
        commitProperties();
        dispatchEvent(new Event(CURRENTPERSON_CHANGED_EVENT));
    }


    /* Events */
    private function loadCompleteHandler(e:Event):void {
        var peopleService:PeopleService = e.currentTarget as PeopleService;
        people = peopleService.people;
    }

    /* Functions */
    private function commitProperties():void{
        if(peopleChanged){
            peopleChanged = false;
        }
        if(currentPersonChanged){
            currentPersonChanged = false;
        }
    }

    public function loadPeople(billId:String):void{
        var peopleService:PeopleService = new PeopleService();
        peopleService.addEventListener(Event.COMPLETE, loadCompleteHandler);
        peopleService.load(billId);
    }

    public function addPerson(personVO:PersonVO):void{
        _people.push(personVO);
        dispatchEvent(new Event(PeopleCollection.PEOPLE_CHANGED_EVENT));
    }

    public function writePeople(billId:String):void{
        var peopleService:PeopleService = new PeopleService();
        peopleService.people = people;
        peopleService.write(billId);
    }

    public function deleteCurrentPerson(personID:String, billId:String):void{
        var peopleService:PeopleService = new PeopleService();
        var i:int = people.indexOf(currentPerson);

        // delete from list
        people.splice(i, 1);

        // delete bill from json
        peopleService.deletePerson(personID, billId);

    }
}
}
internal class Enforcer{}