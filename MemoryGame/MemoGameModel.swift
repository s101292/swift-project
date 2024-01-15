import SwiftUI

struct MemoGameModel<CardContent> where CardContent:Equatable{
    var score1 = 0
    var score2 = 0
    var status = "remember"
    
    private (set) var cards : Array<Card>
    private (set) var needToFind : CardContent
    private (set) var looseCard : CardContent
    
    init(numberOfPairsOfCards: Int, cardContentFactory : (Int)->CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            let uuid = UUID()
            cards.append(Card(content: content, id: "\(uuid)a"))
            cards.append(Card(content: content, id: "\(uuid)b"))
            cards.append(Card(content: content, id: "\(uuid)c"))
            cards.append(Card(content: content, id: "\(uuid)d"))
            cards.append(Card(content: content, id: "\(uuid)e"))
        }
        needToFind = getRandomEmoji()
        looseCard = "💣" as! CardContent

        showAll()
        cards.shuffle()
    }
    
    mutating func changeCardSet(numberOfPairsOfCards: Int, cardContentFactory : (Int)->CardContent) {
        cards = []
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            let uuid = UUID()
            cards.append(Card(content: content, id: "\(uuid)a"))
            cards.append(Card(content: content, id: "\(uuid)b"))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = index(of: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            cards[chosenIndex].isFaceUp = true
            cards[chosenIndex].isMatched = true

            if (status == "player1") {
                if cards[chosenIndex].content == needToFind {
                    score1 += 1
                } else if cards[chosenIndex].content == looseCard {
                    score1 = 0
                } 

                status = "player2"
            } else if (status == "player2") {
                if cards[chosenIndex].content == needToFind {
                    score2 += 1
                    showAll()
                } else if cards[chosenIndex].content == looseCard {
                    score2 = 0
                } else {
                    showAll()
                }

                status = "round_end"
            }
        }
    }
    
    func index(of card: Card) -> Int? {
        for index in cards.indices {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }

    func getRandomEmoji() -> CardContent {
        let emojis = ["🦁", "🐋", "🐨", "🦌", "🦉"]
        return emojis.randomElement() as! CardContent
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }

    mutating func showAll() {
        cards.indices.forEach { index in
            cards[index].isFaceUp = true
        }
    }

    mutating func hideAll() {
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
        }
        status = "player1"
    }

    mutating func restartGame() {
        score1 = 0
        score2 = 0
        nextRound()
    }

    mutating func resetAll() {
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }

    mutating func nextRound() {
        if (score1 >= 3 || score2 >= 3) {
            if (score1 > score2) {
                status = "player2_loose"
            } else if (score2 > score1) {
                status = "player1_loose"
            } else {
                status = "draw"
            }
        } else {
            resetAll()
            showAll()
            status = "show"

            needToFind = getRandomEmoji()
        }
    }
    
    struct Card : Equatable, Identifiable{
        var isFaceUp = false
        var isMatched = false
        var content : CardContent
        var id: String
        
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
