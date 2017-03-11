//
//  saveFile.swift
//  Wheels Within Wheels
//
//  Created by Liam Pierce on 3/2/17.
//  Copyright © 2017 Liam Pierce. All rights reserved.
//

import Foundation


class saveFile{
    let Name:String;
    let fileURL:URL;
    
    init(withName n:String){
        self.Name = n;
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        fileURL = (url?.appendingPathComponent(n).appendingPathExtension("txt"))!;
    }
    
    public func write(Data:String)->String?{
        do{
            try Data.write(to: fileURL, atomically:true,encoding:String.Encoding.utf8);
        }catch let error as NSError{
            return fileURL.description + " " + error.localizedDescription;
        }
        return nil;
    }
    
    public func append(Data:String)->String?{
        let dataEnc = ("\n\(Data)").data(using: String.Encoding.utf8, allowLossyConversion: false)!
        if !FileManager.default.fileExists(atPath: fileURL.path){
            return self.write(Data:Data);
        }
        
        let hndl = try? FileHandle(forWritingTo: fileURL)
        hndl?.seekToEndOfFile()
        hndl?.write(dataEnc)
        hndl?.closeFile()
        return nil;
    }
    
    public func read()->String?{
        return try? String(contentsOfFile:fileURL.path, encoding:String.Encoding.utf8);
    }
    
    public func remove(){
        try? FileManager.default.removeItem(atPath:fileURL.path);
    }
}
