//
//  EHObject.swift
//  enHueco
//
//  Created by Diego on 9/16/15.
//  Copyright © 2015 Diego Gómez. All rights reserved.
//

import Foundation

/// Represents an object that can be synchronized using the Synchronization Manager
class EHSynchronizable: NSObject, NSCoding
{
    var ID: String!
    var lastUpdatedOn: NSDate
    
    init(ID: String!, lastUpdatedOn: NSDate)
    {
        self.ID = ID
        self.lastUpdatedOn = lastUpdatedOn
    }
    
    required init?(coder decoder: NSCoder)
    {
        guard
            let lastUpdatedOn = decoder.decodeObjectForKey("lastUpdatedOn") as? NSDate
        else
        {
            return nil
        }
        
        self.ID = decoder.decodeObjectForKey("ID") as? String
        self.lastUpdatedOn = lastUpdatedOn
        
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(ID, forKey: "ID")
        coder.encodeObject(lastUpdatedOn, forKey: "lastUpdatedOn")
    }
    
    func isOutdatedBasedOnDate(date: NSDate) -> Bool
    {
        return date.compare(lastUpdatedOn).rawValue > 0
    }
}
