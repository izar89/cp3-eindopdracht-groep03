package be.devine.cp3.billsplit.model.service {
import starling.events.EventDispatcher;

public class SplitService extends EventDispatcher {

    public function SplitService() {
        trace("[SplitService] in split");
    }

    // total bill amount + array all people
    public function shared(total:Number, people:Array){

        var equalprice:Number;
        equalprice = (total / people.length);

        return equalprice.toFixed(2);
    }

    // total bill amount + array all prices
    public function ownPrice(total:Number, prices:Array){

        var rest:Number = total;

        for each(var price:Number in prices){
            rest -= price;
        }

        return rest.toFixed(2);
    }

    // total bill amount + array all percentages
    public function percentage(total:Number, percentages:Array){

        var rest:Number = total;

        for each(var percentage:Number in percentages){
            rest -= ((total * percentage) / 100);
        }

        return rest.toFixed(2);
    }

}
}