package be.devine.cp3.billsplit.vo {

public class BillVO {

    public var id:String;
    public var name:String;
    public var total:Number;
    public var billType:String;

    public function toString():String{
        return name;
    }
}}
