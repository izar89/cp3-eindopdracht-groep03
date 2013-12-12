/**
 * User: Stijn Heylen
 * Date: 02/12/13
 * Time: 18:07
 */
package be.devine.cp3.billsplit.vo {

public class BillVO {

    public var id:uint;
    //public var billType:Object; //TODO Create BillType Class ?
    public var name:String;
    public var created:Date;
    public var updated:Date;
    public var total:Number;

    public function toString():String{
        return name;
    }
}
}
