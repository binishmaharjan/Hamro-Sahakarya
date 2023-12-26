import SwiftUI

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
    var selectedColor: Color = .clear
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
                    .foregroundStyle(selectedColor)
            )
            .disabled(true)
            .onTapGesture {
               onTapped?()
            }
    }
}

extension TextFieldStyle where Self == ColorPickerTextFieldStyle {
    /// A secure text field style with custom icon decoration for color pickers.
    public static func colorPicker(_ image: Image, selectedColor: Color = .clear, onTapped: (() -> Void)?) -> ColorPickerTextFieldStyle {
        return ColorPickerTextFieldStyle(image: image, selectedColor: selectedColor, onTapped: onTapped)
    }
}
