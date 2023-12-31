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
            save: { try await session.save(account: $0) },
            remove: { try await session.remove(account: $0) },
            updateImageUrl: { try await session.updateImageUrl(account: $0, imageUrl: $1) },
            changePassword: { try await session.changePassword(account: $0, password: $1) },
            fetchAllMembers: { try await session.fetchAllMembers() },
            fetchAllMembersWithLoan: { try await session.fetchAllMemberWithLoan() },
            changeStatusForUser: { try await session.changeStatusForUser(account: $0) },
            addMonthlyFeeFor: { try await session.addMonthlyFeeFor(account: $0, balance: $1) },
            loanMember: { try await session.loanMember(account: $0, loan: $1) },
            loanReturned: { try await session.loanReturned(account: $0, loan: $1) },
            updateExtraAndExpenses: { try await session.updateExtraAndExpenses(groupDetail: $0, extra: $1, expenses: $2) },
            updateAmountFor: { try await session.updateAmountFor(account: $0, balance: $1) },
            fetchGroupDetail: { try await session.fetchGroupDetail() },
            fetchNotice: { try await session.fetchNotice() },
            updateNotice: { try await session.updateNotice(account: $0, message: $1) }
        )
    }
}

extension UserDataClient {
    actor Session {
        func fetch (uuid: AccountId) async throws -> Account {
            let reference = Firestore.firestore().collection("members").document(uuid)
            
            let user = try await reference.getDocument(as: Account.self)
            return user
        }
        
        func save(account: Account) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            
            try reference.setData(from: account)
        }
        
        func remove(account: Account) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            
            try await reference.delete()
        }
        
        func updateImageUrl(account: Account, imageUrl: ImageUrl) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["icon_url": imageUrl]
            
            try await reference.updateData(updateData)
        }
        
        func changePassword(account: Account, password: Password) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["keyword" : password]
            
            try await reference.updateData(updateData)
        }
        
        func fetchAllMembers() async throws -> [Account] {
            let reference = Firestore.firestore().collection("members")
            let snapshots = try await reference.getDocuments()
            
            var users: [Account] = try snapshots.documents.map {
                try $0.data(as: Account.self)
            }

            return users
        }
        
        func fetchAllMemberWithLoan() async throws -> [Account] {
            let reference = Firestore.firestore().collection("members")
            
            let snapshots = try await reference.whereField("loan_taken", isGreaterThan: 0).getDocuments()
            
            var users: [Account] = try snapshots.documents.map {
                try $0.data(as: Account.self)
            }

            return users
        }
        
        func changeStatusForUser(account: Account) async throws -> Void {
            let newStatus: Status = account.status == .admin ? .member : .admin
            let updateData = ["status": newStatus.rawValue]
            let reference = Firestore.firestore().collection("members").document(account.id)
            
            try await reference.updateData(updateData)
        }
        
        func addMonthlyFeeFor(account: Account, balance: Balance) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["balance": account.balance + balance]
            
            try await reference.updateData(updateData)
        }
        
        func loanMember(account: Account, loan: Loan) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["loan_taken": account.loanTaken + loan]
            
            try await reference.updateData(updateData)
        }
        
        func loanReturned(account: Account, loan: Loan) async throws -> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["loan_taken": account.loanTaken - loan]
            
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
        
        func updateAmountFor(account: Account, balance: Balance) async throws-> Void {
            let reference = Firestore.firestore().collection("members").document(account.id)
            let updateData = ["balance": balance]
            
            try await reference.updateData(updateData)
        }
        
        func fetchGroupDetail() async throws -> GroupDetail {
            let reference = Firestore.firestore().collection("hamro_sahakarya").document("detail")
            
            let groupDetail = try await reference.getDocument(as: GroupDetail.self)
            return groupDetail
        }
        
        func fetchNotice() async throws -> Notice {
            let reference = Firestore.firestore().collection("notice").limit(to: 1).order(by: "date_created", descending: true)
            let snapshots = try await reference.getDocuments()
            
            guard let snapshot = snapshots.documents.first else {
                throw AppError.ApiError.emptyData
            }
            
            let notice = try snapshot.data(as: Notice.self)
            
            return notice
        }
        
        func updateNotice(account: Account, message: String) async throws -> Void {
            let notice = Notice(
                message: message, 
                admin: account.username, 
                dateCreated: Date.now.toString
            )
            let reference = Firestore.firestore().collection("notice").document(notice.dateCreated)
            
            try reference.setData(from: notice)
        }
    }
}
