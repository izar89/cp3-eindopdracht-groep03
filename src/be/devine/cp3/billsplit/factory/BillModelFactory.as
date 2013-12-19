package be.devine.cp3.billsplit.factory {
import be.devine.cp3.billsplit.model.BillModel;

public class BillModelFactory {
    public static function createBillModelFromObject(bill:Object):BillModel{
        var billModel:BillModel = new BillModel();
        billModel.id = bill.id;
        billModel.name = bill.name;
        billModel.total = bill.total;
        billModel.billType = bill.billType;
        return billModel;
    }
}
}