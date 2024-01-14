
import SwiftUI

class MemoGameViewModel : ObservableObject{
    private static let emojis = [Color.black : [
                                    "🦁", "🐋", "🐨", "🦌", "🦉","💣"
                                ]]
    @Published var themeColor = Color.black
    static var theme = Color.black
    
    private static func createMemoGameModel() -> MemoGameModel<String> {
        return MemoGameModel<String>(numberOfPairsOfCards: 6) { index in
                if emojis[theme]!.indices.contains(index) {
                    return emojis[theme]![index]
                } else {
                    return "??"
                }
            }
    }
    
    @Published private var model = createMemoGameModel()
    
    var score1: Int {
        model.score1
    }

    var score2: Int {
        model.score2
    }

    var status: String {
        model.status
    }

    var needToFind: MemoGameModel<String>.Card {
        model.needToFind
    }
    
    var cards: [MemoGameModel<String>.Card] {
        model.cards
    }
    
    func shuffle() {
        model.shuffle()
    }

    // func showAll() {
    //     model.showAll()
    // }

    // func resetAll() {
    //     model.resetAll()
    // }
    
    func choose(_ card: MemoGameModel<String>.Card) {
        model.choose(card)
    }
    
    func changeTheme(color: Color) {
        // themeColor = color
        // MemoGameViewModel.theme = color
        // model.score = 0
        
        // model.changeCardSet(numberOfPairsOfCards: 8) {
        //     index in
        //     if MemoGameViewModel.emojis[MemoGameViewModel.theme]!.indices.contains(index) {
        //         return MemoGameViewModel.emojis[MemoGameViewModel.theme]![index]
        //     } else {
        //         return "??"
        //     }
        // }
    }
}
