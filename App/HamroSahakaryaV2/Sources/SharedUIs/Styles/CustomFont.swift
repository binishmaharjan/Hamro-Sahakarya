import SwiftUI

public enum CustomFont: String, CaseIterable {
    case regular = "Inter-Regular"
    case semibold = "Inter-SemiBold"
    case bold = "Poppins-Bold"
}

extension Font.TextStyle {
    public var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 24
        case .title3: return 20
        case .headline, .body: return 17
        case .subheadline, .callout: return 15
        case .footnote: return 13
        case .caption, .caption2: return 12
        @unknown default:
            return 8
        }
    }
}

extension Font {
    private static func custom(_ font: CustomFont, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
    
    public static let customLargeTitle = custom(.bold, relativeTo: .largeTitle)
    public static let customTitle = custom(.bold, relativeTo: .title)
    public static let customTitle2 = custom(.bold, relativeTo: .title2)
    public static let customTitle3 = custom(.bold, relativeTo: .title3)
    
    public static let customBody = custom(.regular, relativeTo: .body)
    public static let customSubHeadline = custom(.regular, relativeTo: .subheadline)
    public static let customFootnote = custom(.regular, relativeTo: .footnote)
    public static let customCaption = custom(.regular, relativeTo: .caption)
    
    public static let customHeadline = custom(.semibold, relativeTo: .headline)
    public static let customSubHeadline2 = custom(.semibold, relativeTo: .subheadline)
    public static let customFootnote2 = custom(.semibold, relativeTo: .footnote)
    public static let customCaption2 = custom(.semibold, relativeTo: .caption2)
}

public struct CustomFontManager {
    public static func registerFonts() {
        CustomFont.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
