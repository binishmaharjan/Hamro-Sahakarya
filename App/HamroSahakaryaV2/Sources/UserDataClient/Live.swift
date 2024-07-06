import Foundation
import Dependencies
import SharedModels
import FirebaseFirestore

// MARK: Dependency (liveValue)
extension UserDataClient: DependencyKey {
    public static let liveValue = UserDataClient.live()
}

// MARK: - Live Implementation
extension UserDataClient {
    public static func live() -> UserDataClient {
        let session = Session()
        
        return UserDataClient(
            fetch: { try await session.fetch(uuid: $0) },
            save: { try await session.save(user: $0) },
            remove: { try await session.remove(user: $0) },
            updateImageUrl: { try await session.updateImageUrl(user: $0, imageUrl: $1) },
            changePassword: { try await session.changePassword(user: $0, password: $1) },
            fetchAllMembers: { try await session.fetchAllMembers() },
            fetchAllMembersWithLoan: { try await session.fetchAllMemberWithLoan() },
            changeStatus: { try await session.changeStatusForUser(user: $0) },
            addMonthlyFee: { try await session.addMonthlyFeeFor(user: $0, balance: $1) },
            loanGiven: { try await session.loanGiven(user: $0, loan: $1) },
            loanReturned: { try await session.loanReturned(user: $0, loan: $1) },
            updateExtraAndExpenses: { try await session.updateExtraAndExpenses(groupDetail: $0, extra: $1, expenses: $2) },
            updateAmount: { try await session.updateAmountFor(user: $0, balance: $1) },
            fetchGroupDetail: { try await session.fetchGroupDetail() },
            fetchNotice: { try await session.fetchNotice() },
            updateNotice: { try await session.updateNotice(user: $0, message: $1) }
        )
    }
}

extension UserDataClient {
    actor Session {
        func fetch (uuid: UserId) async throws -> User {
            let reference = Firestore.firestore().collection("members").document(uuid)
            
            let user = try await reference.getDocument(as: User.self)
            return user
        }
        
        func save(user: User) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            
            try reference.setData(from: user)
        }
        
        func remove(user: User) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            
            try await reference.delete()
        }
        
        func updateImageUrl(user: User, imageUrl: ImageUrl) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["icon_url": imageUrl]
            
            try await reference.updateData(updateData)
        }
        
        func changePassword(user: User, password: Password) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["keyword" : password]
            
            try await reference.updateData(updateData)
        }
        
        func fetchAllMembers() async throws -> [User] {
            let reference = Firestore.firestore().collection("members")
            let snapshots = try await reference
                .whereField("status", isNotEqualTo: Status.developer.rawValue)
                .getDocuments()
            
            let users: [User] = try snapshots.documents.map {
                try $0.data(as: User.self)
            }

            return users
        }
        
        func fetchAllMemberWithLoan() async throws -> [User] {
            let reference = Firestore.firestore().collection("members")
            
            let snapshots = try await reference
                .whereField("loan_taken", isGreaterThan: 0)
                .getDocuments()
            
            let users: [User] = try snapshots.documents.map {
                try $0.data(as: User.self)
            }

            return users
        }
        
        func changeStatusForUser(user: User) async throws -> Void {
            let newStatus: Status = user.status == .admin ? .member : .admin
            let updateData = ["status": newStatus.rawValue]
            let reference = Firestore.firestore().collection("members").document(user.id)
            
            try await reference.updateData(updateData)
        }
        
        func addMonthlyFeeFor(user: User, balance: Balance) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["balance": user.balance + balance]
            
            try await reference.updateData(updateData)
        }
        
        func loanGiven(user: User, loan: Loan) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["loan_taken": user.loanTaken + loan]
            
            try await reference.updateData(updateData)
        }
        
        func loanReturned(user: User, loan: Loan) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["loan_taken": user.loanTaken - loan]
            
            try await reference.updateData(updateData)
        }
        
        func updateExtraAndExpenses(groupDetail: GroupDetail, extra: Balance, expenses: Balance) async throws -> Void {
            let reference = Firestore.firestore().collection("hamro_sahakarya").document("detail")
            let updateData = [
                "extra": groupDetail.extra + extra,
                "expenses": groupDetail.expenses + expenses
            ]
            
            try await reference.updateData(updateData)
        }
        
        func updateAmountFor(user: User, balance: Balance) async throws-> Void {
            let reference = Firestore.firestore().collection("members").document(user.id)
            let updateData = ["balance": balance]
            
            try await reference.updateData(updateData)
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            let reference = Firestore.firestore().collection("hamro_sahakarya").document("detail")
            
            let groupDetail = try await reference.getDocument(as: GroupDetail.self)
            return groupDetail
        }
        
        func fetchNotice() async throws -> NoticeInfo {
            let reference = Firestore.firestore().collection("notice").limit(to: 1).order(by: "date_created", descending: true)
            let snapshots = try await reference.getDocuments()
            
            guard let snapshot = snapshots.documents.first else {
                throw AppError.ApiError.emptyData
            }
            
            let notice = try snapshot.data(as: NoticeInfo.self)
            
            return notice
        }
        
        func updateNotice(user: User, message: String) async throws -> Void {
            let notice = NoticeInfo(
                message: message, 
                admin: user.username,
                dateCreated: Date.now.toString(for: .dateTime)
            )
            let reference = Firestore.firestore().collection("notice").document(notice.dateCreated)
            
            try reference.setData(from: notice)
        }
    }
}
