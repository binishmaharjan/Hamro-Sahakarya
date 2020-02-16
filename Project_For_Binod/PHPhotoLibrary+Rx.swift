//
//  PHPhotoLibrary+Rx.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/05.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
  static var authorized: Observable<Bool> {
    return Observable.create { observer in

      DispatchQueue.main.async {
        if authorizationStatus() == .authorized {
          observer.onNext(true)
          observer.onCompleted()
        } else {
          observer.onNext(false)
          requestAuthorization { newStatus in
            observer.onNext(newStatus == .authorized)
            observer.onCompleted()
          }
        }
      }

      return Disposables.create()
    }
  }
}

