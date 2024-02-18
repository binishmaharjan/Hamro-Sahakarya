import SwiftUI
import ComposableArchitecture
import SharedUIs
import SharedModels

public struct ProfileView: View {
    public init(store: StoreOf<Profile>) {
        self.store = store
    }
    
    @Bindable private var store: StoreOf<Profile>
    
    public var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        profileView
                    }
                    
                    Section {
                        memberMenus
                    }
                    
                    Section {
                        adminMenus
                    } header: {
                        Text("Admin Menu")
                            .font(.customSubHeadline2)
                            .offset(x: -16)
                    }
                    .textCase(nil)
                    
                    Section {
                        otherMenus
                    } header: {
                        Text("Others")
                            .font(.customSubHeadline2)
                            .offset(x: -16)
                    }
                    .textCase(nil)
                    
                    Section {
                        signOutButton
                    } footer: {
                        VStack {
                            Text("HamroSahakarya")
                            Text("v8.0.0")
                        }
                        .font(.customSubHeadline2)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.top, -16)
                .tint(#color("large_button"))
                .font(.customSubHeadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .customNavigationBar(#localized("Profile"))
            .background(#color("background"))
            .onAppear {
                store.send(.onAppear)
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.membersList, action: \.destination.membersList),
                destination: { MembersListView(store: $0).withCustomBackButton() }
            )
            .navigationDestination(
                item: $store.scope(state: \.destination?.changePassword, action: \.destination.changePassword),
                destination: { ChangePasswordView(store: $0).withCustomBackButton() }
            )
        }
    }
}

// MARK: View Parts
extension ProfileView {
    private var profileView: some View {
        VStack {
            BorderedImageView(urlString: store.iconUrl)
                .frame(width: 69, height: 69)
            
            Text(store.username)
                .font(.customHeadline)
            
            Text(store.email)
                .font(.customSubHeadline2)
                .foregroundStyle(#color("white"))
        }
        .background(
            #img("img_background")
                .resizable()
                .scaledToFill()
                .frame(height: 170)
                .blur(radius: 5)
        )
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var memberMenus: some View {
        ForEach(Menu.Member.allCases, id: \.self) { menu in
            MenuOptionView(menu: menu) {
                store.send(.onMemberMenuTapped(menu))
            }
        }
    }
    
    private var adminMenus: some View {
        ForEach(Menu.Admin.allCases, id: \.self) { menu in
            MenuOptionView(menu: menu) {
                store.send(.onAdminMenuTapped(menu))
            }
        }
    }
    
    private var otherMenus: some View {
        ForEach(Menu.Other.allCases, id: \.self) { menu in
            MenuOptionView(menu: menu) {
                store.send(.onOtherMenuTapped(menu))
            }
        }
    }
    
    private var signOutButton: some View {
        Button {
            store.send(.onSignOutButtonTapped)
        } label: {
            Text("Sign out")
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ProfileView(
        store: .init(
            initialState: .init(user: .mock),
            reducer: Profile.init
        )
    )
}
