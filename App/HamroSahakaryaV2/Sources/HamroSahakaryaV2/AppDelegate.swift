import UIKit
import ComposableArchitecture
import Firebase
import AppFeatureV2
import SharedUIs

public final class AppDelegate: NSObject, UIApplicationDelegate {
    private var _store: StoreOf<AppDelegateReducer>?

    var store: StoreOf<AppDelegateReducer> {
        if let _store {
            return _store
        }
        let store = Store(initialState: AppDelegateReducer.State(), reducer: AppDelegateReducer.init)
        self._store = store
        return store
    }

    private(set) lazy var viewStore = ViewStore(store, observe: { $0 })
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Call method to register custom font
        CustomFontManager.registerFonts()
        // Setup Firebase
        setupFirebaseServer()
        
        viewStore.send(.didFinishLaunching)
        
        return true
    }
}

// MARK: Firebase
extension AppDelegate {
    private func setupFirebaseServer(){
        FirebaseApp.configure()
    }
}

@Reducer
struct AppDelegateReducer {
    @ObservableState
    struct State: Equatable {
        var rootState = Root.State()
    }

    enum Action {
        case didFinishLaunching
        case rootAction(Root.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching, .rootAction:
                return .none
            }
        }

        Scope(state: \.rootState, action: \.rootAction) {
            Root()
        }
    }
}
