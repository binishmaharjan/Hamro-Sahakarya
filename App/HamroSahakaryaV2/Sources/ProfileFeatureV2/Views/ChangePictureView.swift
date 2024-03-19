import SwiftUI
import ComposableArchitecture
import SharedUIs

public struct ChangePictureView: View {
    public init(store: StoreOf<ChangePicture>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<ChangePicture>
    
    public var body: some View {
        VStack {
            VStack {
                
            }
            .frame(width: 300, height: 300)
            .background(Color.red.opacity(0.3))
            .padding(.top, 8)
            
            VStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.3))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(#color("background"))
        .customNavigationBar(#localized("Change Picture"))
    }
}

// Views
extension ChangePictureView {
    private var updateButton: some View {
        Button {
//            store.send(.updateButtonTapped)
        } label: {
            HStack {
                Image(systemName: "arrow.right")
                Text(#localized("Change Password"))
                    .font(.customHeadline)
            }
            .largeButton()
        }
    }
}

#Preview {
    ChangePictureView(
        store: .init(
            initialState: .init(),
            reducer: ChangePicture.init
        )
    )
}
