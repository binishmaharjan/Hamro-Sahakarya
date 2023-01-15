// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let blueBG = ImageAsset(name: "Blue BG")
  public static let iconIPadPro = ImageAsset(name: "Icon-iPadPro")
  public static let hamroSahakarya = ImageAsset(name: "hamro_sahakarya")
  public static let iconAccountSelected = ImageAsset(name: "icon_account_selected")
  public static let iconAccountUnselected = ImageAsset(name: "icon_account_unselected")
  public static let iconArrow = ImageAsset(name: "icon_arrow")
  public static let iconBack = ImageAsset(name: "icon_back")
  public static let iconBalance = ImageAsset(name: "icon_balance")
  public static let iconCalendar = ImageAsset(name: "icon_calendar")
  public static let iconClose = ImageAsset(name: "icon_close")
  public static let iconDetailSelected = ImageAsset(name: "icon_detail_selected")
  public static let iconDetailUnselected = ImageAsset(name: "icon_detail_unselected")
  public static let iconGraphSelected = ImageAsset(name: "icon_graph_selected")
  public static let iconGraphUnselected = ImageAsset(name: "icon_graph_unselected")
  public static let iconHidden = ImageAsset(name: "icon_hidden")
  public static let iconHide = ImageAsset(name: "icon_hide")
  public static let iconHome = ImageAsset(name: "icon_home")
  public static let iconHomeH = ImageAsset(name: "icon_home_h")
  public static let iconLoanTaken = ImageAsset(name: "icon_loan_taken")
  public static let iconLog = ImageAsset(name: "icon_log")
  public static let iconLogH = ImageAsset(name: "icon_log_h")
  public static let iconMemberSince = ImageAsset(name: "icon_member_since")
  public static let iconMoney = ImageAsset(name: "icon_money")
  public static let iconNoticeSelected = ImageAsset(name: "icon_notice_selected")
  public static let iconNoticeUnselected = ImageAsset(name: "icon_notice_unselected")
  public static let iconProfile = ImageAsset(name: "icon_profile")
  public static let iconProfileH = ImageAsset(name: "icon_profile_h")
  public static let iconSetting = ImageAsset(name: "icon_setting")
  public static let iconStatus = ImageAsset(name: "icon_status")
  public static let noImage = ImageAsset(name: "no_image")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
