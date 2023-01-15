import Core
import Foundation
import RxSwift

public protocol NoticeViewModelProtocol {
    var message: Observable<String> { get }
    var admin: Observable<String> { get }
    var dateCreated: Observable<String> { get }
}

public struct NoticeViewModel: NoticeViewModelProtocol {
    public let message: Observable<String>
    public let admin: Observable<String>
    public let dateCreated: Observable<String>
    
    public init(notice: Observable<Notice>) {
        self.message = notice.map { $0.message }
        self.admin = notice.map { "From: \($0.admin)" }
        self.dateCreated = notice.map { $0.dateCreated.toDateAndTime.toGregorianMonthDateYearString }
    }
}
