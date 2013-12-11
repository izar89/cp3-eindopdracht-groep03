/**
 * User: Stijn Heylen
 * Date: 11/12/13
 * Time: 13:14
 */
package be.devine.cp3.billsplit.factory {
import be.devine.cp3.billsplit.vo.BillVO;

public class BillVOFactory {
    public static function createBillVOFromObject(bill:Object):BillVO{
        var billVO:BillVO = new BillVO();
        billVO.id = bill.id;
        billVO.name = bill.name;
        billVO.created = bill.created as Date;
        billVO.updated = bill.updated as Date;
        billVO.total = bill.total;
        billVO.paid = bill.paid;
        return billVO;
    }
}
}
