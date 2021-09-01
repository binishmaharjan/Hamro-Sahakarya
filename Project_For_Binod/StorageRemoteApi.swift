//
//  StorageRemoteApi.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/15.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import PromiseKit

protocol StorageRemoteApi {
    func saveImage(userSession: UserSession, image: UIImage) -> Promise<URL>
    func downloadTermsAndCondition() -> Promise<Data>
}
