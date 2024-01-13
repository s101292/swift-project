import SwiftUI

struct TransformIntoCard: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View{
        content
            .rotation3DEffect(
                .degrees(isFaceUp ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
                    
            )
            .animation(.linear(duration: 0.5), value: isFaceUp)
    }
}

extension View{
    func transformIntoCard(isFaceUp: Bool) -> some View{
        self.modifier(TransformIntoCard(isFaceUp: isFaceUp))
    }
}
