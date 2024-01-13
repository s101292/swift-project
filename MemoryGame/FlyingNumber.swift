import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Text("\(number,specifier: "%+d")")
            .foregroundStyle(number < 0 ? .red : .blue)
            .shadow(color: .black, radius: 1)
            .offset(y: offset)
            .opacity(offset == 0 ? 1 : 0)
            .onAppear{
                withAnimation(.linear(duration: 1.5)){
                    offset = number < 0 ? +100 : -100
                }
            }
            .onDisappear{
                offset = 0
            }
    }
}
