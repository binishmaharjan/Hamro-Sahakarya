import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AppPlugins: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        Localized.self,
        Color.self,
        Image.self,
    ]
}
