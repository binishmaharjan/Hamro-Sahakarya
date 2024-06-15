import Foundation
import ComposableArchitecture
import PDFKit
import UserApiClient

@Reducer
public struct TermsAndCondition {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable { }
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        
        @Presents var destination: Destination.State?
        var pdfDocument: PDFDocument?
        var isLoading: Bool = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        
        case onAppear
        case onFetchPDFResponse(Result<Data, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                guard state.pdfDocument == nil else { return .none }
                state.isLoading = true
                return .run { send in
                    await send(
                        .onFetchPDFResponse(
                            Result {
                                try await userApiClient.downloadTermsAndCondition()
                            }
                        )
                    )
                }
                
            case .onFetchPDFResponse(.success(let data)):
                state.pdfDocument = PDFDocument(data: data)
                state.isLoading = false
                return .none
                
            case .onFetchPDFResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .destination, .binding:
                return .none
            }
        }
    }
}
