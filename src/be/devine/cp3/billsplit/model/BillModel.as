package be.devine.cp3.billsplit.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class BillModel extends EventDispatcher{

    public static const BILLTYPE_CHANGED_EVENT:String = "billTypeChanged";

    public var id:String;
    public var name:String;
    public var total:Number;
    private var _billType:String;
    private var billTypeChanged:Boolean;

    /* Constructor */
    public function BillModel() {}

    /* Getters & setters */
    [Bindable(event="billTypeChanged")]
    public function get billType():String {
        return _billType;
    }
    public function set billType(value:String):void {
        if (_billType == value) return;
        _billType = value;
        dispatchEvent(new Event(BILLTYPE_CHANGED_EVENT));
    }
}
}
