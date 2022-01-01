//
//  LoginView.swift
//  FireBaseChat
//
//  Created by candyline on 2021-12-31.
//

import SwiftUI
import Firebase

// fix SwiftUI preivew crash from reinitializing Auth
class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    var auth: Auth
    
    override init() {
        FirebaseApp.configure()
        
        auth = Auth.auth()
        super.init()
    }
    
}

struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("Create Account", selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05)))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func createAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create account with error \(err)")
                loginStatusMessage = "Failed to create account with error \(err)"
                return
            }
            
            print("User created successfully \(result?.user.uid ?? "nada")")
            loginStatusMessage = "User created successfully \(result?.user.uid ?? "nada")"
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login with error \(err)")
                loginStatusMessage = "Failed to login with error \(err)"
                return
            }
            
            print("User Logged in successfully \(result?.user.uid ?? "nada")")
            loginStatusMessage = "User Logged in successfully \(result?.user.uid ?? "nada")"
        }
    }
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createAccount()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
