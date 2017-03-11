//
//  Table.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 3/9/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

class Table{
    
    private(set) static var TabIndex = 0; //For Tables.
    private(set) static var Ind = 0; //For Records
    private(set) static var Sorts = [String]();
    
    static func incTabInd()->Int{
        TabIndex += 1;
        return TabIndex;
    }
    
    static func incInd()->Int{
        Ind += 1;
        return Ind;
    }
    
    static func resetIds(To:Int){
        self.Ind = To;
        self.TabIndex = To;
        Record.resetIds(To:0);
    }
    
    static func setSort(Index:Int,Sort:String){
        Sorts.insert(Sort,at:Index - 1);
    }
    
    static func getSort(Index:Int)->String{
        return Sorts[Index - 1]
    }
    
    var TableIndex = 0;
    var Saves = [String](); //Data saved in system.
    var Indexes = [String](); //Data saved as key in system.
    
    var Records = [Record]();
    
    var multiplexer = [String:[String:Set<Int>]]();
    
    init(withLists:[String],Keys:[String]){
        self.TableIndex = Table.incTabInd();
        Table.setSort(Index:self.TableIndex,Sort:"");
        self.Indexes = Keys;
        self.Saves = withLists;
        for Key in Keys{
            multiplexer[Key] = [String:Set<Int>]();
        }
    }
    
    func setSort(ToIndex Ind:String){
        Table.setSort(Index:self.TableIndex,Sort:Ind);
    }
    
    func getSort()->String{
        return Table.getSort(Index:self.TableIndex);
    }
    
    func replex(Index:String,toValue val:String,Id:Int){
        if var set = multiplexer[Index]![val] {
            set.insert(Id);
            multiplexer[Index]![val] = set;
        }else{
            var newSet = Set<Int>();
            newSet.insert(Id);
            multiplexer[Index]![val] = newSet;
        }
    }
    
    func deplex(Index:String,Value val:String,Id:Int){
        if var set = multiplexer[Index]![val] {
            set.remove(Id);
        }
    }
    
    func add(Data:[String:String]){
        let Id = Table.incInd();
        let NewRecord = Record(fromTable:self.TableIndex,withId:Id,Data:Data);
        for Index in Indexes{ //For every index type.
            let val = Data[Index] ?? "";
            replex(Index:Index,toValue:val,Id:Id);
        }
        Records.insert(NewRecord,at:Id - 1);
    }
    
    func sortedGet(Data:[String:String])->[Record]{
        if Table.getSort(Index: self.TableIndex) != ""{
            return get(Data:Data).sorted();
        }
        return get(Data:Data);
    }
    
    func get(Data:[String:String])->[Record]{
        print(Data);
        var Un = Set<Int>(Records.map({$0.tabId}));
        for (Index,Value) in Data{
            guard let MUL = multiplexer[Index] else{
                print("Error getting record : Index '\(Index) did not exist.");
                return [Record]();
            }
            
            if let recordSet = MUL[Value]{
                Un = Un.intersection(recordSet);
            }else{
                return [Record]();
            }
            
            if (Un.count == 0){
                return [Record]();
            }
        }
        
        return Un.map({Records[$0 - 1]});
    }
    
    func mod(Record:Int,Index:String,toValue:String){
        let fRecord = Records[Record];
        deplex(Index:Index,Value:fRecord.get(Index:Index),Id:fRecord.tabId);
        Records[Record].mod(Index: Index, toValue: toValue);
        replex(Index:Index,toValue:toValue,Id:fRecord.tabId);
    }

}
