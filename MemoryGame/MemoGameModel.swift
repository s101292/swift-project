import SwiftUI

struct MemoGameModel<CardContent> where CardContent:Equatable{
    var score1 = 0
    var score2 = 0
    var status = "remember"
    
    private (set) var cards : Array<Card>
    private (set) var needToFind : Card
    private (set) var looseCard : Card
    
    init(numberOfPairsOfCards: Int, cardContentFactory : @escaping (Int)->CardContent) {
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

        let delayInSeconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
            self?.hideAll()
        }
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

            if cards[chosenIndex].content == needToFind.content {
                cards[chosenIndex].isMatched = true
                print("match")
                score1 += 1
            }

            if cards[chosenIndex].content == looseCard.content {
                print("loose")
                score1 = 0
            }

            cards[chosenIndex].isFaceUp = true
        }
    }
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
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
    }

    mutating func resetAll() {
        cards.indices.forEach { index in
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    struct Card : Equatable, Identifiable{
        var isFaceUp = false {
                    didSet {
                        if oldValue && !isFaceUp{
                            hasBeenSeen = true
                        }
                    }
                }
        var hasBeenSeen = false
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
