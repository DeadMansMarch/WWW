//
//  Payment.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 2/27/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation

struct Payment{
    private(set) static var paymentId = 0;
    
    static func IncId()->Int{
        paymentId += 1;
        return paymentId;
    }
    
    static func resetIds(To:Int){
        Payment.paymentId = To;
    }
    
    let paymentId:Int;
    let CustomerId:Int;
    let OrderId:Int;
    let Amount:Double;
    
    init(CustomerId cid:Int,OrderId oid:Int,Amount amt:Double){
        self.paymentId = Payment.IncId();
        self.CustomerId = cid;
        self.OrderId = oid;
        self.Amount = amt;
    }
}
