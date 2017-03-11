//
//  RepairListing.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

struct Repair{
    var Repairs = ["silver","gold","platinum"];
    var Days = [4,7,10];
    var Prices:[Int];
    
    init(_ PriceList:[Int]){
        self.Prices = PriceList
    }
    
    
    
    func getRepair(Type:String)->String{
        if (Repairs.contains(Type)){
            return Type
        }
        
        var Max:Int = 0;
        var Rep = "";
        var correctedType = "";
        for Repair in Repairs{
            let M:Int = match(Repair,Type);
            if (Max < M){ Max = M; Rep = Repair; }
        }
        while true{
            if (getIndex(Type: Rep) != nil){
                if (Interface.notify("Corrected level to : '\(Rep)'")){
                    correctedType = Rep;
                }else{
                    correctedType = Interface.activefix();
                }
            }else{
                correctedType = Interface.activefix(Data: "Please correct repair type manually : ");
            }
            
            if getIndex(Type:correctedType) != nil{
                return correctedType;
            }
            
        }
    }
    
    private func getIndex(Type:String)->Int?{
        return Repairs.index(of:Type);
    }
    
    func getDays(Type:String)->Int?{
        if let Ind = getIndex(Type:Type){
            return Days[Ind];
        }
        return nil;
    }
    
    func getPrice(Type:String)->Int?{
        if let Ind = getIndex(Type:Type){
            return Prices[Ind];
        }
        return nil;
    }
    
    mutating func addListing(Type:String,Price:Int,Time:Int){
        Repairs.append(Type);
        Prices.append(Price);
        Days.append(Time);
    }
    
}
