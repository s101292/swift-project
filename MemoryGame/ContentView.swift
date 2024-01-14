import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MemoGameViewModel = MemoGameViewModel()
    @State private var lastScoreChange: (points: Int, cardId: String) = (0, "0")
    
    var body: some View {
     VStack {
        if viewModel.status == "player1_loose" || viewModel.status == "player2_loose" {
            switch viewModel.status {
            case "player1_loose":
                Text("Player1 lost").font(.title2)
            case "player2_loose":
                Text("Player2 lost").font(.title2)
            default:
                EmptyView()
            }
        } else {
            Text("Minefield 💣").font(.title2)
            ScrollView {
                cards.animation(.default, value: viewModel.cards)
            }
            Text("Let's find: " + viewModel.needToFind.content).font(.title2).padding(.bottom, 20)

            HStack(spacing: 20) {
                ScoreBox(score: viewModel.score1, playerName: "Player 1", color: Color.blue)
                switch viewModel.status {
                case "player1":
                    Text("Player 1, your turn! Good luck!").multilineTextAlignment(.center)
                case "player2":
                    Text("Player 2, your turn! Good luck!").multilineTextAlignment(.center)
                case "remember":
                    Text("Let's remember for 10sec...").multilineTextAlignment(.center)
                default:
                    EmptyView()
                }
                ScoreBox(score: viewModel.score2, playerName: "Player 2", color: Color.green)
            }

            switch viewModel.status {
            case "player1", "player2":
                EmptyView()
            case "round_end":
                Button(action: {
                    viewModel.hideAll()
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
            default:
                Button(action: {
                    viewModel.hideAll()
                }) {
                    Text(viewModel.status == "remember" ? "REMEMBER" : "START GAME")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(20)
                }
            }
            // themeButtonsDisplay
        }
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