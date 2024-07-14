import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct LicenseView: View {
    public init(store: StoreOf<License>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<License>
    
    public var body: some View {
        VStack(spacing: 24) {
            List {
                ForEach(store.licenses) { license in
                    NavigationLink {
                        if let licenseText = license.licenseText {
                            ScrollView {
                                Text(licenseText)
                                    .padding()
                            }
                            .navigationTitle(license.name)
                            .withCustomBackButton()
                        }
                    } label: {
                        Text(license.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
        .customNavigationBar(#localized("License"))
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    LicenseView(
        store: .init(
            initialState: .init(),
            reducer: License.init
        )
    )
}
