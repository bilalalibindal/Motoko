import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Text "mo:base/Text";

module {
    public type Result<Ok, Err> = Result.Result<Ok, Err>;
    public type HashMap<Ok, Err> = HashMap.HashMap<Ok,Err>;
    public type Member = {
        name : Text;
        age : Nat;
    }        
};