import SwiftUI

struct ThemeButtonView: View {
    @ObservedObject var viewModel: MemoGameViewModel
    var imageName: String
    var content: String
    var ownColor = Color.blue
    
    var body: some View {
        Button(action: {
            viewModel.changeTheme(color: ownColor)
        }, label: {
            VStack{
                Image(systemName: imageName).font(.title)
                Text(content)
            }
        })
    }
}
