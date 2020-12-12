//
//  LoginUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//
//  Login screen that handles a user trying to login, register, or auto logs in if possible
//

import SwiftUI

struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                
                // Extension view
                CovidLogo()
                
                Spacer()
                
                // Username TextField
                TextField("Username", text: $username)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .frame(width: geometry.size.width / 1.1)
                    .disableAutocorrection(true)
                
                // Password TextField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .frame(width: geometry.size.width / 1.1)
                
                // Extension view
                LoginButton(username: username.lowercased(), password: password, geometry: geometry)
                
                // Register Button
                Button(action: {
                    let contentView = RegisterUI()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Create an Account")
                        .foregroundColor(.white)
                        .padding(6)
                        .frame(width: geometry.size.width / 1.1)
                        .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
               
                // Load local data
                let defaults = UserDefaults.standard
                
                // Try to auto login the user if they logged in last time the app was open
                if let currUsername = defaults.string(forKey: "currUsername") {
                    username = currUsername
                    if let currPassword = defaults.string(forKey: "currPassword") {
                        resetDefaults()
                        defaults.setValue(currUsername, forKey: "currUsername")
                        defaults.setValue(currPassword, forKey: "currPassword")
                        
                        // Network function to login user
                        NetworkLogin.loginUser(username: currUsername, password: currPassword, handler: userloginHandler)

                    }
                }
            }
        }
    }
    
    // HANDLER : For network function to login user (Case: Auto login)
    func userloginHandler(res: Bool, error: String, firstName: String?, lastName: String?) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                // Get ready to save local data
                let defaults = UserDefaults.standard
                
                // handler retrieves user's first and last name from server -> save them locally
                if let first_name = firstName {
                    defaults.setValue(first_name, forKey: "firstName")
                }
                if let last_name = lastName {
                    defaults.setValue(last_name, forKey: "lastName")
                }
                
                // Now that we are logged in move on to main screen (within the Tab View Controller)
                let contentView = TabControllerUI(username: username)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }
        }
        
    }
}

// EXTENSION VIEW : Holds the CovidCode Team Logo
struct CovidLogo: View {
    var body: some View {
        VStack {
            HStack {
                Image("qr-code")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
        }
    }
}

// EXTENSION VIEW : Holds the button that handles loging a user in
struct LoginButton: View {
    var username: String            // Passed in from username TextField in main view
    var password: String            // Passed in from password TextField in main view
    @State var errorMsg: String = ""
    @State private var showingAlert = false
    var geometry: GeometryProxy
    
    var body: some View {
        Button(action: {
            resetDefaults()
            
            // Network function to login user
            NetworkLogin.loginUser(username: username, password: password, handler: userloginHandler)
            
        }) {
            Text("Login")
                .foregroundColor(.white)
                .padding(6)
                .frame(width: geometry.size.width / 1.1)
                .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(username.isEmpty || password.isEmpty || password.count < 8 )
        // Notify user of login status
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
        }
    }
    
    // HANDLER : For network function to login user (Case: Not auto logging in)
    func userloginHandler(res: Bool, error: String, firstName: String?, lastName: String?) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                // Get ready to save local data
                let defaults = UserDefaults.standard
                
                // Save the user's username and password for auto login next time
                defaults.setValue(username, forKey: "currUsername")
                defaults.setValue(password, forKey: "currPassword")
                
                // handler retrieves user's first and last name from server -> save them locally
                if let first_name = firstName {
                    defaults.setValue(first_name, forKey: "firstName")
                }
                if let last_name = lastName {
                    defaults.setValue(last_name, forKey: "lastName")
                }
                
                // Now that we are logged in move on to main screen (within the Tab View Controller)
                let contentView = TabControllerUI(username: username)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }
        } else {
            errorMsg = error
            showingAlert = true
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Used to clear all values in User Defaults (local storage)
func resetDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}
