//
//  FirebaseLogicManager.swift
//  enHueco
//
//  Created by Diego Montoya Sefair on 8/25/16.
//  Copyright © 2016 Diego Gómez. All rights reserved.
//

import Foundation

protocol FirebaseLogicManager {
    static func firebaseUser(errorHandler errorHandler: BasicCompletionHandler) -> FIRUser?
}

extension FirebaseLogicManager {
    
    static func firebaseUser(errorHandler errorHandler: BasicCompletionHandler) -> FIRUser? {
        assertionFailure()
        dispatch_async(dispatch_get_main_queue()){ completionHandler(error: GenericError.NotLoggedIn) }
    }
}