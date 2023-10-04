

import SwiftUI
import Firebase




@main
struct ToDoAIDemoApp: App {
    @ObservedObject var appState: AppState = AppState()
    var body: some Scene {
        WindowGroup {
                NavigationStack(path: $appState.navigationPath){
                    ChatListView()
                        .environmentObject(appState)
                }
        }
    }
}
