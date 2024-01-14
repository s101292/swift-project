import SwiftUI

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