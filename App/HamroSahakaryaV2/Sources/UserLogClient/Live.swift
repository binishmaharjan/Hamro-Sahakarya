import Foundation
import ComposableArchitecture
import SharedModels
import FirebaseFirestore

// MARK: Dependency (liveValue)
extension UserLogClient: DependencyKey {
    public static let liveValue = UserLogClient.live()
}

// MARK: - Live Implementation
extension UserLogClient {
    public static func live() -> UserLogClient {
        let session = Session()
        
        return UserLogClient(
            fetchLogs: { try await session.fetchLogs() },
            addJoinedLog: { try await session.addJoinedLog(user: $0) },
            addMonthlyFeeLog: { try await session.addMonthlyFeeLog(admin: $0, user: $1, amount: $2) },
            addExtraOrExpensesLog: { try await session.addExtraOrExpensesLog(extraOrExpenses: $0, admin: $1, amount: $2, reason: $3) },
            addAmountOrDeductAmountLog: { try await session.addAmountOrDeductAmountLog(addOrDeduct: $0, admin: $1, user: $2, amount: $3) },
            addLoanMemberLog: { try await session.addLoanMemberLog(admin: $0, user: $1, loan: $2) },
            addLoanReturnedLog: { try await session.addLoanReturnedLog(admin: $0, user: $1, loan: $2)},
            addRemoveMemberLog: { try await session.addRemoveMemberLog(admin: $0, user: $1) }
        )
    }
}

extension UserLogClient {
    actor Session {
        func fetchLogs() async throws -> [GroupLog] {
            let reference = Firestore.firestore().collection("logs").order(by: "date_created", descending: true)
            
            let snapshots = try await reference.getDocuments()
            var logs: [GroupLog] = try snapshots.documents.map {
                try $0.data(as: GroupLog.self)
            }
            
            return logs
        }
        
        func addJoinedLog(user: User) async throws -> Void {
            let logCreator = user.username, logTarget = user.username
            let balance = user.balance
            let log = generateLog(logType: .joined, logCreator: logCreator, logTarget: logTarget, amount: balance, reason: "")
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            
            try logReference.setData(from: log)
        }
        
        func addMonthlyFeeLog(admin: User, user: User, amount: Balance) async throws -> Void {
            let logCreator = admin.username, logTarget = user.username
            let log = generateLog(logType: .monthlyFee, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
        
        func addExtraOrExpensesLog(extraOrExpenses: ExtraOrExpenses, admin: User, amount: Balance, reason: String) async throws -> Void {
            let logCreator = admin.username, logTarget = ""
            let logType: GroupLogType = (extraOrExpenses == .extra) ? .extra : .expenses
            let log = generateLog(logType: logType, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: reason)
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
        
        func addAmountOrDeductAmountLog(addOrDeduct: AddOrDeduct, admin: User, user: User, amount: Balance) async throws -> Void {
            let logCreator = admin.username, logTarget = user.username
            let logType: GroupLogType = (addOrDeduct == .add) ? .addAmount : .deductAmount
            let log = generateLog(logType: logType, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
           
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
        
        func addLoanMemberLog(admin: User, user: User, loan: Loan) async throws -> Void {
            let logCreator = admin.username, logTarget = user.username
            let log = generateLog(logType: .loanGiven, logCreator: logCreator, logTarget: logTarget, amount: loan, reason: "")
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
        
        func addLoanReturnedLog(admin: User, user: User, loan: Loan) async throws -> Void {
            let logCreator = admin.username, logTarget = user.username
            let log = generateLog(logType: .loanGiven, logCreator: logCreator, logTarget: logTarget, amount: loan, reason: "")
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
        
        func addRemoveMemberLog(admin: User, user: User) async throws -> Void {
            let logCreator = admin.username, logTarget = user.username
            let amount = user.balance
            let log = generateLog(logType: .loanGiven, logCreator: logCreator, logTarget: logTarget, amount: amount, reason: "")
            
            let logReference = Firestore.firestore().collection("logs").document(log.logId)
            try logReference.setData(from: log)
        }
    }
}

// MARK: Helper Methods
extension UserLogClient.Session {
    private func generateRandomID(length: Int) -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let endIndex = String.Index(utf16Offset: length, in: uuid)
        
        return String(uuid[..<endIndex])
    }
    
    private func generateLog(logType: GroupLogType, logCreator: String, logTarget: String, amount: Balance, reason: String) -> GroupLog {
        GroupLog(
            logId: generateRandomID(length: 20),
            dateCreated: Date().toString(for: .dateTime),
            logType: logType,
            logCreator: logCreator,
            logTarget: logTarget,
            amount: amount,
            reason: reason
        )
    }
}
