//
//  UserDefaultsDataStore.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation
import PromiseKit

final class UserDefaultsDataStore: UserDataStore {
    
    private let userProfileCoder: UserProfileCoding
    private let userProfileKey = "UserProfileKey"
    
    init(userProfileCoder: UserProfileCoding) {
        self.userProfileCoder = userProfileCoder
    }
    
    func readUserProfile() -> Promise<UserSession?> {
        return Promise<UserSession?> { [weak self] seal in
            
            guard let self = self else {
                seal.fulfill(nil)
                return
            }
            
            guard let data = UserDefaults.standard.value(forKey: self.userProfileKey) as? Data else {
                seal.fulfill(nil)
                return
            }
            
            do {
                let userProfile = try userProfileCoder.decode(data: data)
                let userSession = UserSession(profile: userProfile)
                seal.fulfill(userSession)
            } catch {
                seal.reject(error)
            }
            
        }
    }
    
    func save(userProfile: UserProfile?) -> Promise<UserSession> {
        
        return Promise<UserSession> { seal in
            
            guard let userProfile = userProfile else {
                seal.reject(HSError.emptyDataError)
                return
            }
            
            let encodedData = userProfileCoder.encode(userProfile: userProfile)
            UserDefaults.standard.set(encodedData, forKey: userProfileKey)
            
            let userSession = UserSession(profile: userProfile)
            seal.fulfill(userSession)
        }
        
    }
    
    func delete(userProfile: UserProfile) -> Promise<UserSession> {
        
        return Promise<UserSession> { seal in
            UserDefaults.standard.removeObject(forKey: userProfileKey)
            
            let userSession = UserSession(profile: userProfile)
            seal.fulfill(userSession)
        }
    }
}

