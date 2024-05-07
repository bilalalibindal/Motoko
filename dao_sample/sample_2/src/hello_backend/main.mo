import Types "types";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";


actor{
  type Result<Ok, Err> = Types.Result<Ok, Err>;
  let ledger = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);
  let name : Text = "Sample Token";
  let symbol : Text = "SMT";

  public query func tokenName() : async Text{
    return name;
  };

  public query func tokenSymbol() : async Text{
    return symbol;
  };

  public func mint(owner : Principal, amount : Nat) : async Result<(), Text>{
    let balanceOwner = Option.get(ledger.get(owner), 0);
    ledger.put(owner, balanceOwner + amount);
    return #ok();
  };

  public func burn(owner : Principal, amount : Nat) : async Result<(), Text>{
    let balanceOwner = Option.get(ledger.get(owner), 0);
    if (amount >= balanceOwner){
      return #err("This principal doesn't have enough token to burn\nCurrent balance : " #Nat.toText(balanceOwner));
    };
    ledger.put(owner, balanceOwner - amount);
    return #ok();
  };

  public shared ({ caller }) func transfer(from : Principal, to : Principal, amount : Nat) : async Result<(), Text>{
    let balanceFrom = Option.get(ledger.get(from), 0);
    let balanceTo = Option.get(ledger.get(to), 0);

    if(balanceFrom < amount){
      return #err("The from balance is not enough for this transfer. \nCurrent balance :" #Nat.toText(balanceFrom));
    };
    ledger.put(from, balanceFrom - amount);
    ledger.put(to, balanceTo + amount);
    return #ok();
  };

  public query func balanceOf(account : Principal) : async Nat{
    return (Option.get(ledger.get(account), 0));
  };

  public query func totalSupply() : async Nat{
    var totalBalance = 0;
    for(balance in ledger.vals()){
      totalBalance := totalBalance + balance;
    };
    return totalBalance;
  };

  public shared ({caller}) func whoami() : async Principal {
    return caller;
  };

};