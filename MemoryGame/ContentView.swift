import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MemoGameViewModel = MemoGameViewModel()
    @State private var lastScoreChange: (points: Int, cardId: String) = (0, "0")
    
    var body: some View {
        VStack{
            Text("Minefield").font(.title2)
            ScrollView{
                cards.animation(.default, value: viewModel.cards)
            }
            HStack{
                Text("result: \(viewModel.score)")
                Button("shuffle"){
                    viewModel.shuffle()
                }
            }.padding(.bottom, 15)
            themeButtonsDisplay
        }.padding()

    }
    
    var cards : some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 68),spacing: 0)], spacing: 0){
            ForEach(viewModel.cards){card in
                ZStack{
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            let previousScore = viewModel.score
                            viewModel.choose(card)
                            let scoreChange = viewModel.score - previousScore
                            lastScoreChange = (scoreChange, card.id)
                        }
                        .transformIntoCard(isFaceUp: card.isFaceUp)
                    
                    if card.id == lastScoreChange.cardId && lastScoreChange.points != 0 {
                        FlyingNumber(number: lastScoreChange.points)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                    lastScoreChange = (0, "0")
                                }
                            }
                    }
                }
            }
        }.foregroundColor(viewModel.themeColor)
    }

    func scoreChange(for cardId: String) -> Int {
        return cardId == lastScoreChange.cardId ? lastScoreChange.points : 0
    }
    
    var themeButtonsDisplay: some View{
        return HStack{
            Spacer()
            ThemeButtonView(viewModel: viewModel, imageName: "tree", content: "topic 1", ownColor: Color.blue)
            Spacer()
            ThemeButtonView(viewModel: viewModel, imageName: "moon", content: "topic 2", ownColor: Color.red)
            Spacer()
            ThemeButtonView(viewModel: viewModel, imageName: "star", content: "topic 3", ownColor: Color.green)
            Spacer()
        }
    }
}
