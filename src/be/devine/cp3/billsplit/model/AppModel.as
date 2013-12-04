/**
 * User: Stijn Heylen
 * Date: 04/12/13
 * Time: 14:06
 */
package be.devine.cp3.billsplit.model {

public class AppModel {

    private static var instance:AppModel;

    private var jsonModel:JSONModel;

    public function AppModel(e:Enforcer) {
        if (e == null) {
            throw new Error("AppModel is a singleton, use getInstance() instead");
        }

        jsonModel = JSONModel.getInstance();
    }

    public static function getInstance():AppModel {
        if (instance == null) {
            instance = new AppModel(new Enforcer());
        }
        return instance;
    }
}
}
internal class Enforcer{}

