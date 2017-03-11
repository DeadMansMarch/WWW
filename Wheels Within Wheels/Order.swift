//
//  Order.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

struct Order : CustomStringConvertible{ // All dates should be measured in days since system start.
    static var Iterator = 0;
    
    static func setIterator(To:Int){
        self.Iterator = To;
    }
    
    let orderId:Int;
    let customerId:Int;
    let brand:String;
    let level:String;
    let price:Int;
    let date:Double;
    
    private(set) var comment:String? = nil;
    private(set) var completed = false;
    private(set) var payed = 0;
    private(set) var completedBy = "";
    private(set) var completedOn = 0.0;
    
    static func IterateId()->Int{
        Order.Iterator += 1;
        return Order.Iterator - 1;
    }
    
    init?(CustomerId:Int,Brand:String,Level:String,Comment:String?){
        self.brand = System.correctBrandname(Brandname: Brand);
        
        guard let fixedLevel = System.correctType(Brand:self.brand,Type:Level) else{
            return nil;
        }
        
        guard let Price = System.getPrice(Key: brand, Type: fixedLevel) else{
            return nil;
        }
        
        self.comment = Comment;
        self.level = fixedLevel;
        self.orderId = Order.IterateId();
        self.price = Price;
        self.date = System.getDate();
        self.customerId = CustomerId;
    }
    
    mutating public func Completed(Name:String,Date:NSDate){
        self.completed = true;
        self.completedBy = Name;
        self.completedOn = System.getDate();
    }
    
    mutating public func Pay(Amount:Int){
        self.payed += Amount;
    }
    
    var description: String{
        return "Order \(self.orderId)";
    }
}
