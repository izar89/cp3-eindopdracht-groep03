package be.devine.cp3.billsplit.vo {

public class PersonVO {
    public var id:String;
    public var billId:String;
    public var name:String;
    public var amount:Number;

    public function toString():String{
        return name + ": $" + amount;
    }
}}