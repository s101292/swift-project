import SwiftUI

struct MemoGameModel<CardContent> where CardContent:Equatable{
    var score1 = 0
    var score2 = 0
    var status = "remember"
    
    private (set) var cards : Array<Card>
    private (set) var needToFind : Card
    private (set) var looseCard : Card
    
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
        let randomTo = (numberOfPairsOfCards - 1) * 5 - 1
        let randomInt = Int.random(in: 0...randomTo)
        needToFind = cards[randomInt]
        looseCard = cards[numberOfPairsOfCards * 5 - 1]

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
                if cards[chosenIndex].content == needToFind.content {
                    score1 += 1
                    status = "player2"
                } else if cards[chosenIndex].content == looseCard.content {
                    score1 = 0
                    status = "player1_loose"
                } else {
                    status = "player2"
                }
            } else if (status == "player2") {
                if cards[chosenIndex].content == needToFind.content {
                    score2 += 1
                    showAll()
                    status = "round_end"
                } else if cards[chosenIndex].content == looseCard.content {
                    score2 = 0
                    status = "player2_loose"
                } else {
                    showAll()
                    status = "round_end"
                }
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

    mutating func resetAll() {
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        cards.shuffle()
    }

    mutating func nextRound() {
        resetAll()
        showAll()
        let randomTo = (7 - 1) * 5 - 1
        let randomInt = Int.random(in: 0...randomTo)
        needToFind = cards[randomInt]
        status = "remember"
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
