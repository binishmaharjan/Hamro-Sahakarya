import SwiftUI

public struct KeyboardDismissible: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                hideKeyboard()
            }
    }
    
    /// Notify the application to hide the keyboard if displayed
    public func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    public func dismissKeyboardOnTap() -> some View {
        modifier(KeyboardDismissible())
    }
}


