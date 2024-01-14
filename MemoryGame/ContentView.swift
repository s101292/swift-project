import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MemoGameViewModel = MemoGameViewModel()
    @State private var lastScoreChange: (points: Int, cardId: String) = (0, "0")
    
    var body: some View {
        return VStack {
            Text("Minefield 💣").font(.title2)
            ScrollView {
                cards.animation(.default, value: viewModel.cards)
            }
            Text("Let's find: " + viewModel.needToFind.content).font(.title3)
            // HStack {
            //     Text("player1: \(viewModel.score1)")
            //     Text("player2: \(viewModel.score2)")
            // }.padding(.bottom, 15)
            HStack(spacing: 20) {
                ScoreBox(score: viewModel.score1, playerName: "Player 1", color: Color.blue)
                ScoreBox(score: viewModel.score2, playerName: "Player 2", color: Color.green)
            }
            Button(action: {
                // Handle button tap
            }) {
                Text("NEXT ROUND")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            //themeButtonsDisplay
        }.padding()
    }
    
    var cards : some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60),spacing: 0)], spacing: 0){
            ForEach(viewModel.cards){card in
                ZStack{
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(2)
                        .onTapGesture {
                            let previousScore = viewModel.score1
                            viewModel.choose(card)
                            let scoreChange = viewModel.score1 - previousScore
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
}

struct ScoreBox: View {
    var score: Int
    var playerName: String
    var color: Color

    var body: some View {
        VStack {
            Text(playerName)
                .font(.headline)
                .foregroundColor(color)

            Text("\(score)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(color)
                .cornerRadius(10)
        }
    }
}