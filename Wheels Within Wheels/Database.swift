//
//  Database.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 3/9/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation


class Database{
    
    private(set) var working = "";
    private(set) var table:Table?;
    let Name:String;
    private(set) var Tables = [String:Table]();
    
    
    init(withName name:String){ //Init does NOTHING useful.
        self.Name = name;
    }
    
    func addTable(withName name:String,Lists:[String],Keys:[String])->Table?{
        guard Tables[name] == nil else{
            print("A table with this name already exists!");
            return nil;
        }
        
        Tables[name] = Table(withLists:Lists,Keys:Keys);
        
        return Tables[name]!;
        
    }
    
    func addTable(withName name:String,Lists:[String])->Table?{
        return addTable(withName:name,Lists:Lists,Keys:Lists);
    }
    
    func front(Table:String){
        self.working = Table;
        self.table = Tables[Table];
    }
    
    func retreat(){
        self.working = "";
        self.table = nil;
    }
    
    func workable()->Bool{
        return (working != "");
    }
    
    func getTable(withName name:String)->Table?{
        return Tables[name];
    }
    
}
