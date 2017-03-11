//
//  System.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

public func match(_ A:String,_ B:String)->Int{
    var Matches:Int = 0;
    
    for i in 0..<((A.characters.count > B.characters.count) ? B.characters.count : A.characters.count){
        let Str = A.index(A.startIndex, offsetBy: i);
        Matches += (A[Str] == B[Str]) ? 1 : 0;
    }
    return Matches;
}

enum OrderSort{
    case Id
    case Customer
}

class System : CustomStringConvertible{
    static let BikeTable = ["trek":Repair([40,60,100]),"cannondale": Repair([40,60,100]),"salsa": Repair([50,70,115]),"jamis": Repair([60,75,120]),"specialized": Repair([50,70,120]),"surly": Repair([45,60,105]),"giant": Repair([40,60,105]),"bianchi": Repair([65,85,135]),"soma":Repair([65,80,135]),"cervelo": Repair([60,75,120])]; //Liam
    let SysId:Int;
    
    let systemSaveFile = saveFile(withName: "Data");
    let logFile = saveFile(withName: "Log");
    
    private(set) var Orders = [Order?]();
    private(set) var Customers = [Customer?]();
    private(set) var Payments = [Payment?]();
    
    private(set) var WorldsOfData = Database(withName: "SystemBase"); //Name is just for clarity, used for multikey access.
    
    init(withId Id:Int){
        SysId = Id;
        DatabasePrep();
    }
    
    static func bikeExists(Key:String)->Bool{ //Checks if a brand exists.
        return BikeTable[Key] != nil;
    }
    
    static func getPrice(Key:String,Type:String)->Int?{ //Returns a price.
        if (bikeExists(Key: Key)){ return BikeTable[Key]!.getPrice(Type:Type); }
        return nil;
    }
    
    static func getDays(Key:String,Type:String)->Int?{ //Returns days.
        if (bikeExists(Key: Key)){ return BikeTable[Key]!.getDays(Type: Type); }
        return nil;
    }
    
    static func correctBrandname(Brandname:String)->String{ //Corrects a brand name.
        if (bikeExists(Key:Brandname)){
            return Brandname;
        }
        
        var Max:Int = 0;
        var Rep = "";
        var correctedBrand = "";
        for Brand in BikeTable.keys{
            let M:Int = match(Brand,Brandname);
            if (Max < M){ Max = M; Rep = Brand; }
        }
        
        while true{
            
            if (System.bikeExists(Key: Rep)){
                if (Interface.notify("Corrected brandname to : '\(Rep)'")){
                    correctedBrand = Rep;
                }else{
                    correctedBrand = Interface.activefix();
                }
            }else{
                correctedBrand = Interface.activefix(Data:"Please correct brandname manually : ");
            }
            
            if System.bikeExists(Key: correctedBrand){
                return correctedBrand;
            }
        }
    }
    
    static func correctType(Brand:String,Type:String)->String?{ //Corrects a level given a corrected brandname.
        return BikeTable[Brand]!.getRepair(Type: Type);
    }
    
    static func getDate()->Double{ // Returns days since epoch, compare against system start.
        return (Date().timeIntervalSince1970 / 86400)
    }
    
    func DatabasePrep(){
        let _ = WorldsOfData.addTable(withName: "Orders",Lists:["OrderId","Brand","Completed","CustomerId"]);
        let _ = WorldsOfData.addTable(withName: "Customers",Lists:["First","Last","CustomerId"]);
        let _ = WorldsOfData.addTable(withName: "Payments",Lists:["CustomerId","OrderId","PaymentId","Amount"]);
    }
    
    func save(withCommand cmd:String)->Bool{
        if logFile.append(Data:cmd) == nil{
            return true;
        }
        return false;
    }
    
    func Save(fileName n:String){ //Rep save.
        systemSaveFile.remove();
        var Data = "";
        Data += self.Customers.reduce("",{$0 + "addc \($1!.First) \($1!.Last) \($1!.Id)"})
        Data += self.Orders.reduce("",{$0 + "addo \($1!.customerId) \($1!.brand) \($1!.level) \($1!.comment ?? "") \($1!.completedOn) \($1!.completedBy)\n"});
        
        if (systemSaveFile.write(Data:Data) == nil){
            print("Saved!");
        }else{
            print("Error during write.");
        }
    }
    
    func makeOrder(_ d: String...)->Int?{ //Add an order to the system, returns orderid.
        let NewOrder = Order(CustomerId: Int(d[0])!, Brand: d[1], Level: d[2], Comment: (d.count > 3) ? d[3] : nil);
        if let Ord = NewOrder{
            if Customers[Ord.customerId] == nil {
                
            }
            Orders.insert(Ord, at: Ord.orderId);
            Interface.update(self.SysId,withValid:"addo \(Int(d[0])!) \(Ord.brand) \(Ord.level)\((Ord.comment != nil) ? Ord.comment! : "")");
            WorldsOfData.front(Table: "Orders");
            WorldsOfData.table!.add(Data: ["OrderId":String(Ord.orderId),"Brand":Ord.brand,"Completed":String(Ord.completed),"CustomerId":String(Ord.customerId)]);
            WorldsOfData.retreat();
            return Ord.orderId;
        }else{
            return nil
        }
    }
    
    func makeCustomer(First:String,Last:String)->Int?{
        let Cr = Customer(First:First,Last:Last);
        
        Customers[Cr.Id] = Cr;
        WorldsOfData.front(Table:"Customers");
        WorldsOfData.table!.add(Data: ["First":Cr.First,"Last":Cr.Last,"CustomerId":String(Cr.Id)]);
        WorldsOfData.retreat();
        return Cr.Id;
    }
    
    func makePayment(CustomerId cid:Int,OrderId oid:Int,Amount amt:Double){
        let pm = Payment(CustomerId:cid,OrderId:oid,Amount:amt);
        Payments[pm.paymentId] = pm;
        WorldsOfData.front(Table:"Payments");
        WorldsOfData.table!.add(Data: ["CustomerId":String(pm.CustomerId),"OrderId":String(pm.OrderId),"PaymentId":String(pm.paymentId),"Amount":String(amt)]);
        WorldsOfData.retreat();
    }
    
    func report(O:Order){ //To be reformatted.
        print("Order Id \(O.orderId)\n\t Completed : [\(O.completed)]");
        print("\tCustomer Name (ID\(O.customerId)): \(Customers[O.customerId]!.Last)");
        print("\tBike Type : \(O.brand)");
        print("\tRepair Type: \(O.level)");
        print("\tCost: \(O.price)");
        print("\tPayed: \(O.payed)")
    }
    
    func orderReport(SortedBy:String,Where:[String:String]){
        WorldsOfData.front(Table: "Orders");
        
        if SortedBy != ""{
            WorldsOfData.table!.setSort(ToIndex: SortedBy);
        }else{
            WorldsOfData.table!.setSort(ToIndex: "");
        }
        
        let recd = WorldsOfData.table!.sortedGet(Data: Where);
        print(recd);
        
        guard recd.count > 0 else{
            print("There are no orders to report on.")
            return;
        }
        
        
        for R:Record in recd{
            report(O:Orders[Int(R.get(Index:"OrderId"))!]!);
        }
        
        WorldsOfData.retreat();
    }
    
    var description: String{ //Worthless atm.
        return "System:";
    }
}

