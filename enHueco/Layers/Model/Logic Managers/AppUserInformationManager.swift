//
//  AppUserInformationManager.swift
//  enHueco
//
//  Created by Diego Montoya Sefair on 2/26/16.
//  Copyright © 2016 EnHueco. All rights reserved.
//

import Foundation

class AppUserInformationManager
{
    //TODO: What is this method for?
    class func fetchAppUser ()
    {
        let appUser = enHueco.appUser
        
        let request = NSMutableURLRequest(URL: NSURL(string: EHURLS.Base + EHURLS.MeSegment)!)
        request.setEHSessionHeaders()
        request.HTTPMethod = "GET"
        
        ConnectionManager.sendAsyncRequest(request, onSuccess: { (JSONResponse) -> () in
            
            let downloadedUser = JSONResponse as! [String : AnyObject]
            
            if appUser.isOutdatedBasedOnDate(NSDate(serverFormattedString: downloadedUser["updated_on"] as! String)!)
            {
                appUser.updateUserWithJSONDictionary(downloadedUser)
                
                try? PersistenceManager.persistData()

                AppUserInformationManager.downloadProfilePicture()
            }
            
            }) { (error) -> () in
                
                print(error)
        }
    }
    
    /**
     Checks for updates on the server including Session Status, Friend list, Friends Schedule, User's Info
     */
    class func fetchUpdates ()
    {
//        fetchUpdatesForFriendRequests()
//        fetchUpdatesForFriendsAndFriendSchedules()
    }
    
    class func fetchUpdatesForAppUserAndSchedule ()
    {
        let appUser = enHueco.appUser
        
        let request = NSMutableURLRequest(URL: NSURL(string: EHURLS.Base + EHURLS.MeSegment)!)
        request.setEHSessionHeaders()
        request.HTTPMethod = "GET"
        
        ConnectionManager.sendAsyncRequest(request, onSuccess: { (JSONResponse) -> () in
            
            let JSONDictionary = JSONResponse as! [String : AnyObject]
            appUser.updateUserWithJSONDictionary(JSONDictionary)
            
            appUser.schedule = Schedule()
            let eventSet = JSONDictionary["gap_set"] as! [[String : AnyObject]]
            
            for eventJSON in eventSet
            {
                let event = Event(JSONDictionary: eventJSON)
                appUser.schedule.weekDays[event.localWeekDay()].addEvent(event)
            }
            
            }) { (error) -> () in
                print(error)
        }
    }
    
    class func pushProfilePicture(image: UIImage)
    {
        let url = NSURL(string: EHURLS.Base + EHURLS.MeImageSegment)
        
        let request = NSMutableURLRequest(URL: url!)
        request.setValue(enHueco.appUser.username, forHTTPHeaderField: EHParameters.UserID)
        request.setValue(enHueco.appUser.token, forHTTPHeaderField: EHParameters.Token)
        
        request.HTTPMethod = "PUT"
        request.setValue("attachment; filename=upload.jpg", forHTTPHeaderField: "Content-Disposition")
        
        let jpegData = NSData(data: UIImageJPEGRepresentation(image, 100)!)
        request.HTTPBody = jpegData
        
        ConnectionManager.sendAsyncDataRequest(request, onSuccess: { (data) -> () in
            
            self.fetchAppUser()
            
        }, onFailure: { (error) -> () in
                
            print(error)
        })
    }
    
    class func downloadProfilePicture()
    {
        if let url = enHueco.appUser.imageURL
        {
            let request = NSMutableURLRequest(URL: url)
            request.setValue(enHueco.appUser.username, forHTTPHeaderField: EHParameters.UserID)
            request.setValue(enHueco.appUser.token, forHTTPHeaderField: EHParameters.Token)
            request.HTTPMethod = "GET"
            
            ConnectionManager.sendAsyncDataRequest(request, onSuccess: { (data) -> () in
                
                let path = ImagePersistenceManager.fileInDocumentsDirectory("profile.jpg")
                ImagePersistenceManager.saveImage(data, path: path, onSuccess: { () -> () in
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(EHSystemNotification.SystemDidReceiveAppUserImage, object: enHueco)
                })
                
            }) { (error) -> () in
                    
                print(error)
            }
        }
    }
}