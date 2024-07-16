
import SwiftUI
import Combine

class LoginViewModel:ObservableObject{
    @Published var loginModel: LoginModel
    @Published  var showAlert = false
    @Published var alertMessage = ""
    @Published var loggedIn = false
    @Published   var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.loginModel = LoginModel(username: "", password: "")
    }
    
    func login() {
        let email = loginModel.username
        let password = loginModel.password
                guard let url = URL(string: "https://mocki.io/v1/eb9705c0-d434-4de8-99ca-7f8639bcfc67") else {
                    return
                }
        let body: [String: String] = [
                    "email": email,
                    "password": password
                ]
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                            guard let httpResponse = response as? HTTPURLResponse,
                                  httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                            return data
                        }
            .decode(type: LoginModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Failed with error: \(error)")
                }
            }, receiveValue: { [weak self] loginModel in
                self?.loginModel = loginModel
                self?.loggedIn = true
            })
            .store(in: &cancellables)
        if email.isEmpty || password.isEmpty {
            showAlert(message: "Please enter both email and password.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(message: "Please enter a valid email.")
            return
        }
        
        if !isValidPassword(password) {
            showAlert(message: "Password must be at least 9 characters long.")
            return
        }
//        loggedIn = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
       let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{9,}$"
       let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
       return passwordPredicate.evaluate(with: password)
     }

    
     private func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}
