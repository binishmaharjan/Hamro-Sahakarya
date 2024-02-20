import SwiftUI
import SharedUIs

struct MenuOptionView: View {
    
    var menu: MenuOption
    var onTapped: () -> Void
    
    var body: some View {
        LabeledContent {
            chevron
        } label: {
            Button {
                onTapped()
            } label: {
                HStack {
                    Image(systemName: menu.icon)
                        .frame(minWidth: 32)
                    
                    Text(menu.title)
                        .foregroundStyle(#color("black"))
                }
            }
        }
    }
}

// MARK: ViewParts
extension MenuOptionView {
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .frame(height: 12)
            .foregroundColor(#color("large_button"))
    }
}

#Preview {
    MenuOptionView(menu: Menu.Admin.changeStatus) { }
}
