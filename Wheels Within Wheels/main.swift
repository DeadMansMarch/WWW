//
//  main.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

var K:Interface = Interface(LoadFile:"system");
K.main();


//Test of Tables.

var RealityOfData = Database(withName: "LiamsBase");
var table = RealityOfData.addTable(withName:"LiamsReality",Lists:["Name","Id","Standing"],Keys: ["Name","Id","Standing"])!;

table.add(Data:["Name":"Id","Id":"1","Standing":"HIGH"]);
table.add(Data:["Name":"Ime","Id":"2","Standing":"HIGH"]);
table.add(Data:["Name":"Iasd","Id":"3","Standing":"HIGH"]);
table.add(Data:["Name":"Idd","Id":"2","Standing":"HIGH"]);
table.add(Data:["Name":"liam","Id":"5","Standing":"HIGH"]);
table.add(Data:["Name":"pierce","Id":"100","Standing":"HIGH"]);

table.setSort(ToIndex: "Name");
print(table.sortedGet(Data: [String:String]()));

