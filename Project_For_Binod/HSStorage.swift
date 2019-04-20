//
//  HSStorage.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/03/26.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol HSStorage{
  func saveImageToStorage(image:UIImage,completion:((String?,Error?)->())?)
}

extension HSStorage{
  func saveImageToStorage(image:UIImage,completion:((String?,Error?)->())?){
    let profileImage = image
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg" // Meta type for the data
    
     let imageData : Data = profileImage.jpegData(compressionQuality: 0.5)!//Converted to JPEG WIth Compression Quality 0.5
    
    let store = Storage.storage()//Access to the storage
    guard let user = HSSessionManager.shared.user else {return} //Current User
    
    //Reference to the user profile images file if file is not available new file will be created
    let storeRef = store.reference().child("\(StorageReference.USER_PROFILE)/\(user.uid)/\(StorageReference.PROFILE_IMAGE)")
    
    //Saving the data to the storage
    DispatchQueue.global(qos: .default).async {
      let _ = storeRef.putData(imageData, metadata: metaData) { (metadata, error) in
        guard let _  = metadata else{
          DispatchQueue.main.async {completion?(nil,error)}
          return
        }
        
        //Getting the url after storing the data to the storage
        storeRef.downloadURL(completion: { (url, error) in
          guard let url = url else {
            DispatchQueue.main.async {completion?(nil,error)}
            return
          }
          //returning the url to save in the database
          DispatchQueue.main.async {completion?(url.absoluteString,error)}
        })
      }
    }
  }
}
