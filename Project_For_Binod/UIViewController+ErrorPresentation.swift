//
//  UIViewController+ErrorPresentation.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/10/19.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {

  // MARK: - Methods
  func present(errorMessage: ErrorMessage) {
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
  }
  
  func present(errorMessage: ErrorMessage,
               withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>) {
    errorPresentation.onNext(.presenting)
    let errorAlertController = UIAlertController(title: errorMessage.title,
                                                 message: errorMessage.message,
                                                 preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      errorPresentation.onNext(.dismissed)
      errorPresentation.onNext(nil)
    }
    errorAlertController.addAction(okAction)
    present(errorAlertController, animated: true, completion: nil)
    
  }
}
