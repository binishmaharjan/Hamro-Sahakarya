import SwiftUI

public struct NavigationBar: View {
    public init(title: String) {
        self.title = title
    }
    
    public var title:String
    
    public var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            
            Text(title)
                .foregroundStyle(#color("black"))
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
        }
            .frame(height: 44)
    }
}

#Preview {
    NavigationBar(title: "Home")
}

// MARK: Custom Navigation Bar
private struct CustomNavigationBar: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear() {
                let appearance = UINavigationBarAppearance()
                appearance.titleTextAttributes = [.foregroundColor: UIColor(#color("large_button"))]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(#color("large_button"))]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
//            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarColorScheme(.dark)
    }
}

extension View {
    public func customNavigationBar(_ title: String) -> some View {
        modifier(CustomNavigationBar(title: title))
    }
}

// MARK: Back Button
public struct BackButton: View {
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.backward")
        }
        .foregroundStyle(#color("large_button"))
        .font(.customHeadline)
    }
}

private struct BackButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
    }
}

extension View {
    public func withCustomBackButton() -> some View {
        modifier(BackButtonModifier())
    }
}

