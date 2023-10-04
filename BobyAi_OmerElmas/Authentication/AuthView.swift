

import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            Text("ChatGpt IOS App")
                .font(.system(.title , weight: .bold))
            
            TextField("Email" , text: $viewModel.emailText)
                .padding()
                .background(.gray.opacity(0.1))
                .textInputAutocapitalization(.never)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if viewModel.isPasswordVisible{
                SecureField("Password" , text: $viewModel.passwordText)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .textInputAutocapitalization(.never)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button {
                    viewModel.authenticate(appState: appState)
                } label: {
                    Text(viewModel.userExists ? "Log In" : "Create User")
                }
                .padding()
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
            }
       


        }.padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
