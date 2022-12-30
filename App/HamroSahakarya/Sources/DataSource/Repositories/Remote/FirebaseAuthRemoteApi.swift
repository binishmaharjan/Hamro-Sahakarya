import CodableFirebase
import Core
import FirebaseAuth
import FirebaseFirestore
import Foundation
import PromiseKit

final class FirebaseAuthRemoteApi: AuthRemoteApi {

    public func signIn(email: String, password: String) -> Promise<String> {
        return Promise<String> { seal in

            DispatchQueue.global(qos: .default).async {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

                    if let error = error {
                        DispatchQueue.main.async {
                            seal.reject(error)
                        }
                        return
                    }

                    guard let userData = result?.user else {
                        DispatchQueue.main.async {
                            seal.reject(HSError.emptyDataError)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        seal.fulfill(userData.uid)
                    }


                    // Login Successful > Get User Data From The Database
                    //          self.serverDataManager.readUser(uid: userData.uid).done { (userProfile) in
                    //            DispatchQueue.main.async { seal.fulfill(userProfile!) }
                    //          }.catch { (error) in
                    //            DispatchQueue.main.async { seal.reject(error) }
                    //          }

                }
            }

        }

    }

    public func signUp(newAccount: NewAccount) -> Promise<String> {
        return Promise<String> { seal in

            DispatchQueue.global(qos: .default).async {
                Auth.auth().createUser(withEmail: newAccount.email, password: newAccount.keyword) { (result, error) in

                    if let error = error {
                        DispatchQueue.main.async { seal.reject(error) }
                        return
                    }

                    guard let userData = result?.user else {
                        DispatchQueue.main.async { seal.reject(HSError.emptyDataError) }
                        return
                    }

                    let changeRequest = userData.createProfileChangeRequest()
                    changeRequest.displayName = newAccount.username
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                            DispatchQueue.main.async { seal.reject(error) }
                            return
                        }
                    }


                    DispatchQueue.main.async { seal.fulfill(userData.uid) }
                }
            }

        }
    }

    public func signOut(userSession: UserSession) -> Promise<UserSession> {
        return Promise<UserSession> { seal in

            DispatchQueue.global(qos: .default).async {
                do {
                    try Auth.auth().signOut()
                    seal.fulfill(userSession)
                } catch {
                    seal.reject(error)
                }
            }

        }
    }

    public func changePassword(newPassword: String) -> Promise<String> {
        return Promise<String> { seal in
            let currentUser = Auth.auth().currentUser
            let completion: (Error?) -> Void = { error in

                if let error = error  {
                    DispatchQueue.main.async { seal.reject(error) }
                    return
                }

                DispatchQueue.main.async {  seal.fulfill(newPassword) }
            }

            DispatchQueue.global().async {
                currentUser?.updatePassword(to: newPassword, completion: completion)
            }
        }
    }
}
