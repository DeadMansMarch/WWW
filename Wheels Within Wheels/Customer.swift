//
//  Customer.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/7/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

class Customer{
    
    let Id:Int;
    let First:String;
    let Last:String;
    
    private(set) var Orders = [Int]();
    private(set) var Transactions = [Int]();
    
    
    static var Inc:Int = 0;
    static func incId()->Int{
        Inc += 1;
        return Inc;
    }
    
    static func setId(To:Int){
        self.Inc = To;
    }
    
    init(First:String,Last:String){
        self.Id = Customer.incId();
        self.First = First;
        self.Last = Last;
    }
    
    init(withId Id:Int,First:String,Last:String){
        self.Id = Id
        self.First = First;
        self.Last = Last;
    }
    
    func add(Order o:Order){
        self.Orders.append(o.orderId);
    }
    
    func add(Transaction t:Payment){
        Transactions.append(t.paymentId);
    }
}
