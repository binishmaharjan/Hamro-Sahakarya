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
        let userSession = try userProfileCoder.decode(data: data)
        seal.fulfill(userSession)
      } catch {
        seal.reject(error)
      }
      
    }
  }
  
  func save(userSession: UserSession?) -> Promise<UserSession> {
    
    return Promise<UserSession> { seal in
      
      guard let userSession = userSession else {
        seal.reject(HSError.emptyDataError)
        return
      }
      
      let encodedData = userProfileCoder.encode(userSession: userSession)
      UserDefaults.standard.set(encodedData, forKey: userProfileKey)
      seal.fulfill(userSession)
    }

  }

  func delete(userSession: UserSession) -> Promise<UserSession> {

    return Promise<UserSession> { seal in
      UserDefaults.standard.removeObject(forKey: userProfileKey)
      seal.fulfill(userSession)
    }
  }
}

