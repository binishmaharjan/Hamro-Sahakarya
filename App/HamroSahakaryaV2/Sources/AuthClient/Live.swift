import Foundation
import Dependencies
import SharedModels
import FirebaseAuth


// MARK: Dependency (liveValue)
extension AuthClient: DependencyKey {
    public static let liveValue = AuthClient.live()
}

// MARK: - Live Implementation
extension AuthClient {
    public static func live() -> AuthClient {
        let session = Session()
        
        return AuthClient(
            signIn: { try await session.signIn(email: $0, password: $1) },
            signUp: { try await session.signUp(newAccount: $0) },
            signOut: {try await session.signOut() },
            changePassword: { try await session.changePassword(newPassword: $0) }
        )
    }
}

extension AuthClient {
    actor Session {
        func signIn (email: Email, password: Password) async throws -> AccountId {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            return authDataResult.user.uid
        }
        
        func signUp(newAccount: NewAccount) async throws -> AccountId {
            let authDataResult = try await Auth.auth().createUser(withEmail: newAccount.email, password: newAccount.keyword)
            
            let changeRequest = authDataResult.user.createProfileChangeRequest()
            changeRequest.displayName = newAccount.username
            
            try await changeRequest.commitChanges()
            
            return authDataResult.user.uid
        }
        
        func signOut() async throws -> Void {
            try Auth.auth().signOut()
        }
        
        func changePassword(newPassword: Password) async throws -> Void {
            let currentUser = Auth.auth().currentUser
            try await currentUser?.updatePassword(to: newPassword)
        }
    }
}
