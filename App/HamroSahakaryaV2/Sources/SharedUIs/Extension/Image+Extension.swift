import SwiftUI
import UIKit

extension Image {
    public init?(from data: Data)  {
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
    }
}
