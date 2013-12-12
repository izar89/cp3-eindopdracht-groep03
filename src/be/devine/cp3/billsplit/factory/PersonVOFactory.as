/**
 * User: Stijn Heylen
 * Date: 11/12/13
 * Time: 13:14
 */
package be.devine.cp3.billsplit.factory {
import be.devine.cp3.billsplit.vo.PersonVO;

public class PersonVOFactory {
    public static function createPersonVOFromObject(person:Object):PersonVO{
        var personVO:PersonVO = new PersonVO();
        personVO.id = person.id;
        personVO.billId = person.billId;
        personVO.name = person.name;
        personVO.amount = person.amount;
        return personVO;
    }
}
}
