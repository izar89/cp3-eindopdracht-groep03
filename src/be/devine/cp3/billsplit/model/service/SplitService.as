package be.devine.cp3.billsplit.model.service {

public class SplitService {

    // total bill amount + array all people
    public static function shared(total:Number, people:Array):Number{
        var equalprice:Number;
        if(people.length == 0){
             equalprice = total;
        } else {
            equalprice = (total / people.length);
        }

        return Math.round(equalprice*100)/100;
    }

    // total bill amount + array all prices
    public static function ownPrice(total:Number, prices:Array):Number{
        var rest:Number = total;
        for each(var price:Number in prices){
            rest -= price;
        }

        return Math.round(rest*100)/100;
    }

    // total bill amount + array all percentages
    public static function percentage(total:Number, percentages:Array):Number{
        var rest:Number = total;

        for each(var percentage:Number in percentages){
            rest -= ((total * percentage) / 100);
        }

        return Math.round(rest*100)/100;
    }
}
}