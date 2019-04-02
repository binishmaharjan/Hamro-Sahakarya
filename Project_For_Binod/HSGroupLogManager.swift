//
//  HSGroupLogManager.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/30.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import CodableFirebase
import FirebaseFirestore

protocol HSGroupLogManager{
  func writeLog(logOwner:String,logCreator:String,amount:Int,
                logType:String,dateCreated:String,completion:((Error?)->())?)
}

extension HSGroupLogManager{
  func writeLog(logOwner:String,logCreator:String,amount:Int,
                logType:String,dateCreated:String,completion:((Error?)->())?){
    
    let logId = randomID(length: 20)
    let log = HSLog.init(lodId: logId, logOwner: logOwner, logCreator: logCreator, amount: amount, logType: logType, dateCreated: dateCreated)
    
    do{
      let logRef = Firestore.firestore().collection(DatabaseReference.LOGS_REF).document(logId)
      let data = try FirestoreEncoder().encode(log) as [String:Any]
      
      DispatchQueue.global().async {
        logRef.setData(data, completion: { (error) in
          if let error = error{
            completion?(error)
            return
          }
          completion?(nil)
        })
      }
    }catch{
      completion?(error)
    }
  }
}
