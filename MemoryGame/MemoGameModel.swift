import SwiftUI

struct MemoGameModel<CardContent> where CardContent:Equatable{
    var score = 0
    
    private (set) var cards : Array<Card>
    private (set) var needToFind : Card
    
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
        let randomInt = Int.random(in: 0...5)
        needToFind = cards[randomInt]
        print(needToFind.content)
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
        print(card.content)
        if let chosenIndex = index(of: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            cards[chosenIndex].isMatched = true

            print(cards[chosenIndex].content)
            print(needToFind.content)

            if cards[chosenIndex].content == needToFind.content {
                print('match')
                score += 1
            }

            cards[chosenIndex].isFaceUp = true
        }
        // if let chosenIndex = index(of: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
        //     if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
        //         if cards[chosenIndex].content == cards[potentialMatchIndex].content {
        //             cards[chosenIndex].isMatched = true
        //             cards[potentialMatchIndex].isMatched = true
        //             score += 4
        //         } else {
        //             if cards[chosenIndex].hasBeenSeen {
        //                 score -= 1
        //             }
        //             if cards[potentialMatchIndex].hasBeenSeen {
        //                 score -= 1
        //             }
        //         }
        //     } else {
        //         indexOfTheOneAndOnlyFaceUpCard = chosenIndex
        //     }
        //     cards[chosenIndex].isFaceUp = true
        // }
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
