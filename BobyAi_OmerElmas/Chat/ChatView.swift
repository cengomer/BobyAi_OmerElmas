

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel : ChatViewModel
    var body: some View {
        VStack {
            chatSelection
            
            ScrollViewReader{scrollView in
                List(viewModel.messages){ message in
                    messageView(for:message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange (of: viewModel.messages) { newValue in
                            scrollToButton(scrollView: scrollView)
                        }
                    
                    
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .listStyle(.plain)
            }
            messageInputView
                .preferredColorScheme(.dark)
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchData()
        }
        
    }
    
    func scrollToButton(scrollView : ScrollViewProxy){
        guard !viewModel.messages.isEmpty , let lastMessage = viewModel.messages.last else { return }
        withAnimation{
            scrollView.scrollTo(lastMessage.id)
        }
    }
    var chatSelection : some View {
        Group {
            if let model = viewModel.chat?.model?.rawValue {
                Text(model)
            } else {
                Picker(selection: $viewModel.selectedModel) {
                    ForEach(ChatModel.allCases , id: \.self) {model in
                        Text(model.rawValue)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
                .padding()

            }
        }
    }
    func messageView(for message: AppMessage) -> some View {
        HStack {
            if (message.role == .user){
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical , 12)
                .background(message.role == .user ? .blue : .white)
                .foregroundColor(message.role == .user ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
            if (message.role == .assistant){
                Spacer()
            }
        }
    }
    var messageInputView: some View {
        HStack {
            TextField("Send a message...", text: $viewModel.messageText)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit {
                    sendMessage()
                }
            Button {
                sendMessage()
            } label: {
                Text("Send")
                    .padding()
                    .background(.blue)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .bold()
            }

        }.padding()
    }
    
    
    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: .init(chatId: ""))
    }
}
