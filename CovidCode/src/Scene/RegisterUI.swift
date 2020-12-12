//
//  RegisterUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/24/20.
//

import SwiftUI


struct RegisterUI: View {
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State private var showingAlert = false

    
    
    var body: some View {
        VStack {
            // HEADER
            ZStack {
                // Back button
                HStack {
                    Button(action: {
                        
                        // Goes back to login page
                        let contentView = ContentView()
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Text("Back").padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            // END HEADER
            Divider()
            Spacer()
            VStack {
                
                // All register fields
                Text("Register")
                    .bold()
                    .foregroundColor(.primary)
                    .padding(10)
                    .font(.system(size: 45))
                Text("Password must be at least 8 characters long")
                    .bold()
                    .foregroundColor(.primary)
                    .padding(10)
                    .multilineTextAlignment(.center)
                Spacer()
                TextField("First Name", text: $first_name)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                TextField("Last Name", text: $last_name)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textContentType(.newPassword)
                
                // EXTENSTION VIEW
                RegisterButton(first_name: first_name, last_name: last_name, username: username.lowercased(), email: email, password: password)
            }.padding()
            Spacer()
        }
    }
}

// ECTENSION VIEW : register for an account with all the entries of the TextFields
struct RegisterButton: View {
    var first_name: String
    var last_name: String
    var username: String
    var email: String
    var password: String
    @State var errorMsg: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            debugPrint("test")
            // Network function to add a user into the CovidCode system
            NetworkAddUser.addUser(first_name: first_name, last_name: last_name, username: username, password: password, email: email, handler: addUserHandler)
            
        }) {
            Text("Register")
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
            
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(username.isEmpty || first_name.isEmpty || last_name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || password.count < 8 )
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
              }
    }
    
    // HANDLER : for the network function of adding a user to the system
    func addUserHandler(res: Bool, error: String) -> () {
        // TODO Change this name and make this the return handler of login
        if (res) {
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                // Set their login values for auto login next time and to populate the upcoming homescreen with their name
                defaults.setValue(username.lowercased(), forKey: "currUsername")
                defaults.setValue(password, forKey: "currPassword")
                defaults.setValue(first_name, forKey: "firstName")
                defaults.setValue(last_name, forKey: "lastName")
                UserDefaults.standard.setValue(username, forKey: username)
                let contentView = TabControllerUI(username: username)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }
        } else {
            showingAlert = true
            errorMsg = error
        }
        
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


struct RegisterUI_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUI()
    }
}
