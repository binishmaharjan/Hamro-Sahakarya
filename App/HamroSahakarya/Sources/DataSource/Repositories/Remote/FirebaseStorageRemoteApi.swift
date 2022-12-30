import Core
import FirebaseStorage
import PromiseKit
import UIKit

public final class FirebaseStorageRemoteApi: StorageRemoteApi {
    public init() {}

    enum ContentType: String {
        case jpeg = "image/jpeg"
    }

    public func saveImage(userSession: UserSession, image: UIImage) -> Promise<URL> {

        let metaData = getMetaData(forContentType: .jpeg)

        let uid = userSession.profile.value.uid

        return putData(image: image, metaData: metaData, uid: uid)
            .then(downloadUrl(uid:))
    }

    /// Download Terms and Conditions pdf from firebase
    public func downloadTermsAndCondition() -> Promise<Data> {
        return Promise<Data> { seal in

            let storage = Storage.storage()
            let pdfReference = storage.reference(withPath: "\(StorageReference.TERMS_AND_CONDITION_REF)/\(StorageReference.TERMS_AND_CONDITION_PDF)")

            pdfReference.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
                if let error = error {
                    DispatchQueue.main.async { seal.reject(error) }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async { seal.reject(HSError.emptyDataError) }
                    return
                }

                DispatchQueue.main.async { seal.fulfill(data) }
            }
        }
    }

    /// Put Data Into FireStore
    private func putData(image: UIImage, metaData: StorageMetadata, uid: String) -> Promise<String> {
        return Promise<String> { [weak self] seal in

            guard let this = self else {
                DispatchQueue.main.async { seal.reject(HSError.imageSaveError) }
                return
            }

            let storageReference = generateStorageReference(for: uid)

            let imageData = image.jpegData(compressionQuality: 0.5)!

            let completion: (StorageMetadata?, Error?) -> Void = { metaData , error  in
                do {
                    try this.checkIfErrorPresent(error: error)
                    try this.checkIfMetadataPresent(metadata: metaData)

                    DispatchQueue.main.async { seal.fulfill(uid) }

                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }

            DispatchQueue.global().async {
                storageReference.putData(imageData, metadata: metaData, completion: completion)
            }

        }
    }

    /// Download the url of the saved Image
    private func downloadUrl(uid: String) -> Promise<URL> {
        return Promise<URL> { [weak self] seal in

            guard let this = self else {
                DispatchQueue.main.async { seal.reject(HSError.imageSaveError) }
                return
            }

            let storageReference = generateStorageReference(for: uid)

            let completion: (URL?, Error?) -> Void = { url, error in
                do {
                    try this.checkIfErrorPresent(error: error)
                    let url = try this.checkIfURLPresent(url: url)

                    DispatchQueue.main.async { seal.fulfill(url) }

                } catch {
                    DispatchQueue.main.async { seal.reject(error) }
                }
            }

            DispatchQueue.global().async {
                storageReference.downloadURL(completion: completion)
            }

        }
    }

}

//MARK: Helper Methods
extension FirebaseStorageRemoteApi {

    private func generateStorageReference(for uid: String) -> FirebaseStorage.StorageReference {
        let storage = Storage.storage()
        let reference = storage.reference()
        let storageReference = reference.child("\(StorageReference.USER_PROFILE)/\(uid)/\(StorageReference.PROFILE_IMAGE)")

        return storageReference
    }

    private func getMetaData(forContentType: ContentType) -> StorageMetadata {
        let metaData = StorageMetadata()
        metaData.contentType = ContentType.jpeg.rawValue
        return metaData
    }

    private func checkIfErrorPresent(error: Error?) throws {
        guard let error = error else { return }
        throw error
    }

    private func checkIfMetadataPresent(metadata: StorageMetadata?) throws {
        guard metadata == nil else { return }
        throw HSError.imageSaveError
    }

    private func checkIfURLPresent(url: URL?) throws -> URL {
        guard let url = url else {
            throw HSError.noImageError
        }
        return url
    }

    private func checkIfImagePresent(image: UIImage?) throws -> UIImage {
        guard let image = image else {
            throw HSError.noImageError
        }

        return image
    }
}
