//
//  Interface.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

public func fit(_ s:String, _ size:Int, right:Bool = true)->String{
    var result = "";
    let sSize = s.characters.count;
    if sSize == size { return s }
    var count = 0;
    if size < sSize{
        for c in s.characters{
            if count < size { result.append(c) } ;
            count += 1;
        }
        return result;
    }
    result = s;
    var addon = "";
    let num = size - sSize;
    for _ in 0..<num{addon.append(" ");}
    if right{ return result + addon }
    return addon + result;
}

public func fitI(_ i:Int, _ size:Int, right:Bool = false)->String{
    let iAsString = "\(i)"
    let newLength = iAsString.characters.count
    return fit(iAsString,newLength > size ? newLength : size,right:right);
}

public func fitD(_ d:Date, _ size: Int, right:Bool = false)->String{
    let df = DateFormatter()
    df.dateFormat = "MM-dd-yyyy"
    let dAsString = df.string(from:d);
    return fit(dAsString,size,right:right);
}

func t(_ Type:Any)->transformationType{
    return transformationType(Example:Type);
}

class Interface{
    private static var printable = true;
    private static var idsys = 0;
    private static var validated = [Int:String]();
    
    let localid = Interface.getId();
    var Sys:System;
    let validator = [
        "addrp":[4:[t(""),t(""),t(1),t(1)]],
        "addo":[3:[t(1),t(""),t("")]],
        "addc":[2:[t(""),t("")]]];
    
    
    
    init(LoadFile:String){
        Sys = System(withId:localid);
    }
    
    init(){
        Sys = System(withId:localid);
    }
    
    static public func getId()->Int{
        idsys += 1;
        return idsys - 1;
    }
    
    static public func update(_ id:Int,withValid Dat:String){
        Interface.validated[id] = Dat;
    }
    
    static public func notify(_ Notif:String)->Bool{ //Notifies user of data change.
        print(Notif, ", is this ok? [y,n]");
        let Resp = readLine();
        if (Resp == "y"){
            return true
        }
        return false
    }
    
    static public func activefix()->String{ //Allows active user change.
        return Interface.activefix(Data: "Please fix manually : ");
    }
    
    static public func activefix(Data:String)->String{ //Allows active user change.
        print(Data);
        repeat{
            if let Resp = readLine(){
                return Resp;
            }
        }while true
    }
    
    private func nInSet(c:String,ins : Int)->Int?{ //Checks for nearest datasize.
        if let dSet = validator[c]{
            for inputsize in (0...ins).reversed(){
                if dSet[inputsize] != nil{
                    return inputsize;
                }
            }
        }
        return 0
    }
    
    private func partValidFor(Command cmd:String,withInputs inp:ArraySlice<String>)->Bool{ // Validates data

        if let validation = validator[cmd]{
            if let InputSize = nInSet(c:cmd,ins:inp.count), let validSet = validation[InputSize]{
                for i in 0..<InputSize{
                    if validSet[i].formation(withData: inp[i + 1]) == nil{
                        return false;
                    }
                }
                return true
            }
            return false
        }
        return true
    }
    
    public static func log(_ Data:Any){
        if Interface.printable{
            print(Data);
        }
    }
    
    public func action(Inp:String)->Bool{ //Will parse and read input.
        var splt = Inp.components(separatedBy: " ");
        var passed = false;
        if partValidFor(Command:splt[0],withInputs:splt[1..<splt.count]) {
            switch(splt[0].lowercased()){
                case "quit":
                    print("Are you sure you want to quit? [y:n]")
                    if (readLine() == "y"){ return true; }
                case "help":
                    let HelpOrd = ["quit","help","addrp","addc","addo","addp","comp","printrp","printcnum","printcname",
                                   "printo","printp","printt","printr","prints","readc","savebs","restorebs"];
                    let HelpMenu = ["quit":"'quit'. Quit the WWW System.",
                                    "help":"'help'. Display this window.",
                                    "addrp":"'addrp [brand] [level] [price] [days]'. Add a repair level to a brand.",
                                    "addc":"'addc [First Name] [Last Name]'. Adds a customer to the database.",
                                    "addo":"'addo [CustomerId] [Brand] [Level] Optional([Comment])'. Creates an order.",
                                    "addp":"'addp [CustomerId] [Date] [Amount]', 'addp [OrderId] [CustomerId] [Date] [Amount]'. Inputs transaction.",
                                    "comp":"'comp [OrderId] [Date]'. Updates order as completed.",
                                    "printrp":"'printrp'. Prints a full repair price table for customer use.",
                                    "printcnum":"'printcnum'. Prints customers by number.",
                                    "printcname":"'printcname [true = First, false = Last]'. Prints customers by name.",
                                    "printo":"'printo', 'printo [Info Scheme as 'Dataname:Value'] Optional([OrderBy])'. Prints simple or complex order reports.",
                                    "printp":"'printp', 'printp [Info Scheme as 'Dataname:Value'] Optional([OrderBy])'. Prints complete payment reports.",
                                    "printt":"'printt', 'printt [Info Scheme as 'Dataname:Value'] Optional([OrderBy])'. Prints complete transaction reports.",
                                    "printr":"'printr', 'printr [Info Scheme as 'Dataname:Value'] Optional([OrderBy])'. Prints complete recievable reports.",
                                    "prints":"'prints', 'prints [Info Scheme as 'Dataname:Value'] Optional([OrderBy])'. Prints complete statements.",
                                    "readc":"'readc [filename]'. Reads and runs commands from a text file on disk.",
                                    "savebs":"'savebs [filename]'. Saves bike shop as commands listing.",
                                    "restorebs":"'restorebs [filename]'. Loads bike shop as command listing from disk.",];
                    let mnu = HelpOrd.map{[$0,HelpMenu[$0]!]};
                    print(mnu.reduce("Commands:\n",{$0 + fit($1[0],12,right:true) + ": \($1[1])\n"}));
                    break;
                case "addrp":
                    break;
                case "addc":
                    let Inputs = nInSet(c:splt[0],ins: splt.count - 1)!
                    let newCustomer:Int?;
                    if (Inputs == 2){
                        newCustomer = Sys.makeCustomer(First: splt[1], Last: splt[2]);
                    }
                    break;
                case "addo":
                    let Inputs = nInSet(c:splt[0],ins: splt.count - 1)!
                    let newOrder:Int?;
                    if (Inputs == 3){
                        var Comment = "";
                        if (splt.count > 4){
                            let slice = splt[4..<splt.count]
                            Comment = slice.reduce("",{$0 + " \($1)"})
                        }
                        newOrder = Sys.makeOrder(splt[1],splt[2],splt[3],Comment)
                    }else{
                        newOrder = nil;
                    }
                    
                    if newOrder != nil{
                        passed = true;
                        print("Order created with order id : \(newOrder!)");
                    }else{
                        print("Order not placed. Please try again with different data.");
                    }
                    
                    
                    break;
                case "reporto": //*****
                    var Filter = [String:String]();
                    let Components = splt.map({$0.components(separatedBy:":")})
                    
                    if splt.count > 1 {
                        var SortedBy:String = "";
                        for i in 1..<Components.count{
                            if Components[i].count > 1{
                                Filter[Components[i][0]] = Components[i][1];
                            }else{
                                SortedBy = Components[i][0];
                            }
                        }
                        Sys.orderReport(SortedBy:SortedBy,Where:Filter);
                    }else{
                        Sys.orderReport(SortedBy:"OrderId",Where:[String:String]());
                    }
                    
                    
                    break;
                case "save":
                    if splt.count > 1{
                        self.Sys.Save(fileName: String(splt[1]) ?? "Data");
                    }else{
                        self.Sys.Save(fileName:"Data");
                    }
                    break;
                case "readc":
                    let File:saveFile;
                    if splt.count > 1{
                        File = saveFile(withName: splt[1]);
                    }else{
                        File = saveFile(withName:"Data");
                    }
                    
                    if let data = File.read(){
                        data.components(separatedBy: "\n").forEach({let _ = self.action(Inp: $0)});
                    }
                    break;
                case "load":
                    if (Interface.notify("Are you sure? This will delete all unsaved data")){
                        Order.setIterator(To: 0);
                        Table.resetIds(To:0);
                        Customer.setId(To: 0);
                        Payment.resetIds(To:0);
                        self.Sys = System(withId:self.localid);
                        let file = (splt.count > 1 ? splt[1] : "Data");
                        let _ = self.action(Inp: "readc \(file)");
                    }
                    break;
                default:
                    print("No such command.");
                    break;
            }
            if passed {
                let validated = Interface.validated[self.localid] ?? Inp;
                
                if !self.Sys.save(withCommand: validated){
                    print("Error autosaving to disk.")
                }
            }
            return false;
        }else{
            print("Invalid options for command : \(splt[0])")
        }
        return false;
    }
    
    public func main(){ //Main run. Call this to activate entire system.
        var Breaker = false;
        while (!Breaker){
            print("Input Command: ");
            let Inp = readLine();
            if Inp != nil{
                Breaker = action(Inp: Inp!)
            }
        }
    }
    
}
