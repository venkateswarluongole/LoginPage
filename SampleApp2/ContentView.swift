import SwiftUI
struct ContentView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false
    @State private var isShowingPassword = false
    var body: some View {
                NavigationView {
                    VStack {
                            Text("Welcome to T-Mobile!")
                                .bold()
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            
                            Text("Please log in")
                                .font(.title3)
                           Spacer()
                            VStack(alignment: .leading, spacing: 20) {
                                TextField("Email or phone number", text: $viewModel.loginModel.username)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(isEmailFocused ? Color.red : Color.gray, lineWidth: 1)
                                    )
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        isEmailFocused = true
                                        isPasswordFocused = false
                                    }
                                    .onSubmit {
                                        isEmailFocused = false
                                    }
                                
                                HStack {
                                    if isShowingPassword {
                                        TextField("Password", text: $viewModel.loginModel.password)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    } else {
                                        SecureField("Password", text: $viewModel.loginModel.password)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        isShowingPassword.toggle()
                                    }) {
                                        Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(isPasswordFocused ? Color.red : Color.gray, lineWidth: 1)
                                )
                                .onTapGesture {
                                    isPasswordFocused = true
                                    isEmailFocused = false
                                }
                                .onSubmit {
                                    isPasswordFocused = false
                                }
                                
                                Button(action: {
                                    viewModel.login()
                                }) {
                                    Text("Log in")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red: 0.952, green: 0.049, blue: 0.742, opacity: 0.781))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $viewModel.showAlert) {
                                    Alert(
                                        title: Text("Error"),
                                        message: Text(viewModel.alertMessage),
                                        dismissButton: .default(Text("OK")) {}
                                    )
                                }
                                NavigationLink(destination: NextScreen(), isActive: $viewModel.loggedIn) {
                                    EmptyView()
                                }
        //                        .hidden()
                                NavigationLink(destination: NextScreen()) {
                                    Text("Need help logging In ?")
                                        .foregroundColor(Color(red: 0.952, green: 0.049, blue: 0.742))
                                        .underline()
                                }
                            }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 20)
                                Text("Get a T-Mobile ID")
                                .padding(30)
                                
                                Spacer()
                            }
                            .padding()
                            .navigationBarItems(trailing: Button(action: {
                            }, label: {
                                Text("Close")
                                    .padding()
                                    .foregroundColor(Color(red: 0.952, green: 0.049, blue: 0.742))
                        }))
                    }
                .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
            }
//           .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct NextScreen: View {
        var body: some View {
            Text("NextScreen")
        }
    }
