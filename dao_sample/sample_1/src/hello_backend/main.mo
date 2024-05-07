import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Types "types";

actor {

  type Member = Types.Member;
  type Result<Ok, Err> = Types.Result<Ok, Err>;
  type HashMap<K, V> = Types.HashMap<K, V>;

  let members = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

  public shared ( {caller} ) func addMember(member : Member) : async Result<(), Text> {
    switch(members.get(caller)){
      case(null){
        members.put(caller, member);
        return #ok();
      };
      case(? oldMember) {
        return #err("Your principal already associated with a member profile");
      };
    };
  };

  public query func getMember(p : Principal) : async Result<Member, Text> {
    switch(members.get(p)){
      case(null){
        return #err("There is no member associated with this principal : " # Principal.toText(p));
      };
      case(? member){
        return #ok(member);
      };
    };
  };

  public shared ( {caller} ) func updateMember(member : Member) : async Result<(), Text> {
    switch(members.get(caller)){
      case(null){
        return #err("There is no member profile associated with your principal : " #Principal.toText(caller));
      };
      case(? oldMember){
        members.put(caller,member);
        return #ok;
      };  
    };
  };

   public query func getAllMembers() : async [Member] {
    return Iter.toArray(members.vals());
  };

  public query func numberOfMembers() : async Nat {
    return members.size();
  };

  public shared ( {caller} ) func removeMember() : async Result<(), Text> {
    switch(members.get(caller)){
      case(null){
        return #err("There is no member profile associated with your principal : " #Principal.toText(caller));
      };
      case(? member){
        members.delete(caller);
        return #ok;
      };  
    };
  };
};