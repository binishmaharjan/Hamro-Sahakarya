import Foundation
import SharedUIs

protocol MenuOption {
    var title: String { get }
    var icon: String { get }
}

public enum Menu {
    public enum Member: Int, CaseIterable, MenuOption {
        case changePicture
        case changePassword
        case members
    }
    
    public enum Admin: Int, CaseIterable, MenuOption {
        case expenseAndExtra
        case monthlyFee
        case loanMember
        case loanReturned
        case addOrDeduct
        case changeStatus
        case removeMember
        case updateNotice
    }
    
    public enum Other: Int, CaseIterable, MenuOption {
        case termsAndCondition
        case license
    }
    
    public enum SignOut: Int, CaseIterable {
        case signOut
    }
}

extension Menu.Member {
    var title: String {
        switch self {
        case .changePicture: return #localized("Change Picture")
        case .changePassword: return #localized("Change Password")
        case .members: return #localized("Members")
        }
    }
    
    var icon: String {
        switch self {
        case .changePicture: return "photo.on.rectangle.angled"
        case .changePassword: return "person.badge.key"
        case .members: return "list.star"
        }
    }
}

extension Menu.Admin {
    var title: String {
        switch self {
        case .changeStatus: return #localized("Change Member Status")
        case .expenseAndExtra: return #localized("Extra Income And Expenses")
        case .monthlyFee: return #localized("Add Monthly Fee")
        case .loanMember: return #localized("Loan Member")
        case .loanReturned: return #localized("Loan Returned")
        case .removeMember: return #localized("Remove Member")
        case .addOrDeduct: return #localized("Add Or Deduct Amount")
        case .updateNotice: return #localized("Update Notice")
        }
    }
    
    var icon: String {
        switch self {
        case .changeStatus: return "person.badge.shield.checkmark"
        case .expenseAndExtra: return "cart"
        case .monthlyFee: return "banknote"
        case .loanMember: return "return.right"
        case .loanReturned: return "return.left"
        case .removeMember: return "person.badge.minus"
        case .addOrDeduct: return "plusminus"
        case .updateNotice: return "exclamationmark.bubble"
        }
    }
}

extension Menu.Other {
    var title: String {
        switch self {
        case .termsAndCondition: return #localized("Terms And Condition")
        case .license: return #localized("License")
        }
    }
    
    var icon: String {
        switch self {
        case .termsAndCondition: return "doc.richtext.fill"
        case .license: return "doc.plaintext"
        }
    }
}
