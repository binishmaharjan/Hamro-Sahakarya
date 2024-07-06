import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct Color: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "Color(\(argument), bundle: .sharedUIs)"
    }
}
