
import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    @EnvironmentObject var appState : AppState
    @State private var showPromptView = false
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .loading , .none:
                Text("Loading chats...")
            case .noResults :
                Text("No chats")
            case .resultFound:
                List {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            
                            VStack(alignment:.leading) {
                                HStack {
                                    Text(chat.topic ?? "BobyAi-OmerElmas")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(chat.model?.rawValue ?? "")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(chat.model?.tintColor ?? .white)
                                        .padding(6)
                                        .background((chat.model?.tintColor ?? .white).opacity(0.1))
                                        .clipShape(Capsule(style : .continuous))
                                }
                                Text(chat.lastMessageTimeAgo)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteChat(chat:chat)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            
                        }
                    }
                    
                }
                .preferredColorScheme(.dark)

            }
            
        }
        .navigationTitle("Chats")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    viewModel.showProfile()
                } label:{
                    Image (systemName: "person")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    Task {
                        do {
                            let chatId = try await  viewModel.createChat(user: appState.currentUser?.uid)
                            
                            appState.navigationPath.append(chatId)
                        } catch {
                            print(error)
                        }
                    }
                } label:{
                    Image (systemName: "square.and.pencil")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                   showPromptView = true
                } label:{
                    Image (systemName: "photo")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingProfileView, content: {
            ProfileView()
        })
        .fullScreenCover(isPresented: $showPromptView, content: {
            PromptView()
        })
        .navigationDestination(for: String.self, destination: { chatId in
            ChatView(viewModel: .init(chatId: chatId))
        })
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchData(user: appState.currentUser?.uid)
            }
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
