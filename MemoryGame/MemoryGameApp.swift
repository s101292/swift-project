import SwiftUI

@main
struct MemoryGameApp: App {
    @StateObject var memoGame = MemoGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: memoGame)
        }
    }
}
