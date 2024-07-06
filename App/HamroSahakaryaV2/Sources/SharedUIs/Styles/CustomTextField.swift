import SwiftUI
import SwiftHelpers

// MARK: BorderedTextFieldStyle
public struct BorderedTextFieldStyle: TextFieldStyle {
    var height: CGFloat
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .frame(height: height, alignment: .top)
            .background(#color("white"))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(#color("large_button"), lineWidth: 2)
            }
    }
}

extension TextFieldStyle where Self == BorderedTextFieldStyle {
    /// A text field style with custom border.
    public static func bordered(height: CGFloat) -> BorderedTextFieldStyle {
        return BorderedTextFieldStyle(height: height)
    }
}

// MARK: IconTextFieldStyle
public struct IconTextFieldStyle: TextFieldStyle {
    var image: Image
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .padding(.leading, 36)
            .background(#color("white"))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
    }
}

extension TextFieldStyle where Self == IconTextFieldStyle {
    /// A text field style with custom icon decoration.
    public static func icon(_ image: Image) -> IconTextFieldStyle {
        return IconTextFieldStyle(image: image)
    }
}

// MARK: SecureTextFieldStyle
public struct SecureTextFieldStyle: TextFieldStyle {
    var image: Image
    var isSecure: Bool
    var onSecureIconTapped: (() -> Void)?
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 52)
//            .padding(15)
            .padding(.leading, 36 + 15)
            .padding(.trailing, 36)
            .background(#color("white"))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
            .overlay(
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .foregroundStyle(#color("secondary"))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        onSecureIconTapped?()
                    }
            )
    }
}

extension TextFieldStyle where Self == SecureTextFieldStyle {
    /// A secure text field style with custom icon decoration.
    public static func secure(_ image: Image, isSecure: Bool, onSecureIconTapped: (() -> Void)?) -> SecureTextFieldStyle {
        return SecureTextFieldStyle(image: image, isSecure: isSecure, onSecureIconTapped: onSecureIconTapped)
    }
}

// MARK: TapOnlyTextFieldStyle
public struct TapOnlyTextFieldStyle: TextFieldStyle {
    var image: Image
    var onTapped: (() -> Void)?
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.icon(image))
            .disabled(true)
            .onTapGesture {
               onTapped?()
            }
    }
}

extension TextFieldStyle where Self == TapOnlyTextFieldStyle {
    /// A secure text field style with custom icon decoration, but not editable.
    public static func tapOnly(_ image: Image, onTapped: (() -> Void)?) -> TapOnlyTextFieldStyle {
        return TapOnlyTextFieldStyle(image: image, onTapped: onTapped)
    }
}

// MARK: ColorPickerTextFieldStyle
public struct ColorPickerTextFieldStyle: TextFieldStyle {
    var image: Image
    var colorHex: ColorHex = "#F77D8E"
    var onTapped: (() -> Void)?
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 52)
            .padding(.leading, 36 + 16)
            .padding(.trailing, 36)
            .background(#color("white"))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .padding(.leading, 36 + 15)
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
                    .foregroundStyle(Color(hex: colorHex))
            )
            .disabled(true)
            .onTapGesture {
               onTapped?()
            }
    }
}

extension TextFieldStyle where Self == ColorPickerTextFieldStyle {
    /// A secure text field style with custom icon decoration for color pickers.
    public static func colorPicker(_ image: Image, colorHex: ColorHex, onTapped: (() -> Void)?) -> ColorPickerTextFieldStyle {
        return ColorPickerTextFieldStyle(image: image, colorHex: colorHex, onTapped: onTapped)
    }
}
