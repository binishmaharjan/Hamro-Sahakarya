import SwiftUI

@freestanding(expression)
public macro localized(_ key: LocalizedStringResource) -> String = #externalMacro(module: "SharedMacros", type: "Localized")

@freestanding(expression)
public macro color(_ key: String) -> Color = #externalMacro(module: "SharedMacros", type: "Color")

@freestanding(expression)
public macro img(_ key: String) -> Image = #externalMacro(module: "SharedMacros", type: "Image")

