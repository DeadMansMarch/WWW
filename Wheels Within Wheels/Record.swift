//
//  Record.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 3/9/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation


class Record : CustomStringConvertible, Comparable{
    
    static func < (A: Record, B: Record) -> Bool {
        let Ind = Table.getSort(Index:A.tabIndex); // Index;
        if (A.get(Index:Ind) < B.get(Index:Ind)){
            return true;
        }
        return false;
    }
    
    static func ==(A:Record,B:Record)->Bool{
        let Ind = Table.getSort(Index:A.tabIndex); // Index;
        if (A.get(Index:Ind) == B.get(Index:Ind)){
            return true;
        }
        return false;
    }
    
    static var Ind = 0;
    static func incId()->Int{
        Ind += 1;
        return Ind;
    }
    
    static func resetIds(To:Int){
        self.Ind = To;
    }
    
    let globId:Int;
    let tabId:Int;
    let tabIndex:Int;
    
    private(set) var recordData = [String:String]();
    
    init(fromTable:Int,withId:Int,Data:[String:String]){
        self.recordData = Data;
        self.globId = Record.incId();
        self.tabId = withId;
        self.tabIndex = fromTable;
    }
    
    func mod(Index:String,toValue:String){
        guard recordData[Index] != nil else{
            print("Modification error : Index '\(Index) does not exist.'");
            return;
        }
        
        recordData[Index] = toValue;
    }
    
    func get(Index:String)->String{
        guard let val = recordData[Index] else{
            print("Get error : Index '\(Index) does not exist.'");
            return "";
        }
        
        return val;
    }
    
    var description:String{
        return recordData.reduce("R[\(globId)][\(tabId)] ",{$0 + "\($1.0):\($1.1)"})
    }
}
