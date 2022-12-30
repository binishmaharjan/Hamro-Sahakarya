import UIKit
import PromiseKit

public protocol StorageRemoteApi {
    func saveImage(userSession: UserSession, image: UIImage) -> Promise<URL>
    func downloadTermsAndCondition() -> Promise<Data>
}
