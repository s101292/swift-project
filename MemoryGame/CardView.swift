import SwiftUI

struct CardView: View {
    var card: MemoGameModel<String>.Card
    
    init(_ card: MemoGameModel<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        let base = RoundedRectangle(cornerRadius: 12)
        base
            .overlay(
                Group{
                        base.fill(.white)
                        base.strokeBorder(lineWidth: 3)
                        Text(card.content)
                            .font(.system(size: 250))
                            .minimumScaleFactor(0.01)
                            .aspectRatio(1, contentMode: .fit)
                            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                            .animation(card.isMatched ? Animation.spin(duration: 2) ! Animation.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true))
                            .if(card.isMatched) { content in
                                content.animation(Animation.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true))
                            }
                    }
                    .opacity(1)
                    //.opacity(card.isFaceUp ? 1 : 0)
            )
            .aspectRatio(2/3, contentMode: .fill)
            .opacity(1)
            //.opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        
    }
}

extension Animation {
    static func spin(duration: Double) -> Animation{
        return Animation.linear(duration: duration).repeatForever(autoreverses: false)
    }
}
