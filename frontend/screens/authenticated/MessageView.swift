import SwiftUI

struct MessageView: View {
    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        VStack {
            if isCurrentUser {
                HStack {
                    Spacer()
                    messageContent
                }
            } else {
                HStack {
                    messageContent
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var messageContent: some View {
        Group {
            if let imageURL = message.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text(message.text)
                    .padding()
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .background(isCurrentUser ? .blue : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: isCurrentUser ? .bottomTrailing : .bottomLeading){
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.title)
                            .rotationEffect(.degrees(isCurrentUser ? -45 : 45))
                            .offset(x: isCurrentUser ? 10 : -10, y: 10)
                            .foregroundColor(isCurrentUser ? .blue : .white)
                    }
            }
        }
    }
}


