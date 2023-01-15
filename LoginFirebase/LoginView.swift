//
//  ContentView.swift
//  LoginFirebase
//
//  Created by David Winfield on 1/12/23.
//

import SwiftUI
import Firebase
import FirebaseAuth


class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}


struct LoginView: View {
    
    @State var isLoginMode = true
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "person.fill")
                            .font(.system(size:64))
                            .padding()
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    SecureField("Password", text: $password)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(Color.red)
                }.padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        }
        else {
            createAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: self.email, password: self.password) {
            result, err in
            if let err = err {
                print("Failed to login user", err)
                loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
    
    private func createAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) {
            result, err in
            if let err = err {
                print("Failed to create user", err)
                loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            //print("Successfully created user: \(result?.user.uid ?? "")")
            loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
