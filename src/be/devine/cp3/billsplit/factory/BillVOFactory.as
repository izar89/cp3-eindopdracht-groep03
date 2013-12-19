package be.devine.cp3.billsplit.factory {
import be.devine.cp3.billsplit.vo.BillVO;

public class BillVOFactory {
    public static function createBillVOFromObject(bill:Object):BillVO{
        var billVO:BillVO = new BillVO();
        billVO.id = bill.id;
        billVO.name = bill.name;
        billVO.total = bill.total;
        billVO.billType = bill.billType;
        return billVO;
    }
}
}