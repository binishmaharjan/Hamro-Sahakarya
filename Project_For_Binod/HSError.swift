//
//  RemoteApiError.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/09.
//  Copyright © 2019 JEC. All rights reserved.
//

import Foundation


enum HSError: Error {
    
    case loginError
    case signUpError
    case networkFailedError
    case dataDecodingError
    case dataEncodingError
    
    case saveDataError
    case readDataError
    case noSnapshotError
    case emptyDataError
    
    case noImageError
    case imageSaveError
    
    case passwordDoesntMatch
    case cannotChangeOwnStatus
    
    case noAuthError
    case unknown
}

extension HSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .passwordDoesntMatch:
            return "Error: Password Doesnot Match"
        case .loginError:
            return "Error: Couldnot Signin"
        case .signUpError:
            return "Error: Couldnot SignUp"
        case .networkFailedError:
            return "Error: No Network Avaiable"
        case .dataDecodingError:
            return "Error: Data Cannot Be Decoded"
        case .dataEncodingError:
            return "Error: Data Cannot Be Encoded"
        case .saveDataError:
            return "Error: Couldnot Save Data"
        case .readDataError:
            return "Error: Couldnot Read Data"
        case .noSnapshotError:
            return "Error: No Snaphot"
        case .emptyDataError:
            return "Error: Empty Data"
        case .noImageError:
            return "Error: No Image"
        case .imageSaveError:
            return "Error: Couldnot Save Image"
        case .cannotChangeOwnStatus:
            return "Error: You Cannot Change Your Own Status"
        case .noAuthError:
            return "Error: Authorization Error"
        default:
            return "Error: Unknown"
        }
    }
    
}


struct RemoteApiErrorFactory {
    
}
