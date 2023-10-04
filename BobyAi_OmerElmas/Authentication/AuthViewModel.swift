

import Foundation

@MainActor
class AuthViewModel : ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var userExists = false
    
    
    let authService = AuthService()
    func authenticate(appState : AppState)  {
        isLoading  =  true
        Task {
            do {
                if isPasswordVisible {
                    let result = try await authService.login(email: emailText, password: passwordText, userExisits: userExists)
                    await MainActor.run(body: {
                        guard let result = result else { return }
                        
                        appState.currentUser = result.user
                    })
                } else {
                    userExists = try await authService.checkUserExists(email: emailText)
                    isPasswordVisible = true
                }
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
        }
    }
}
