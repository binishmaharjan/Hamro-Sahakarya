import UIKit
import PromiseKit

protocol StorageRemoteApi {
    func saveImage(userSession: UserSession, image: UIImage) -> Promise<URL>
    func downloadTermsAndCondition() -> Promise<Data>
}
