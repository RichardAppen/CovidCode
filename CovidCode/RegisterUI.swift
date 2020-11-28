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
            ZStack {
                HStack {
                    Button(action: {
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
            Divider()
            Spacer()
            VStack {
            
            
            
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
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .disableAutocorrection(true)
            TextField("Last Name", text: $last_name)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .disableAutocorrection(true)
            TextField("Username", text: $username)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .disableAutocorrection(true)
            TextField("Email", text: $email)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textContentType(.newPassword)
           // SecureField("Confirm Password", text: $confirm_password)
            //    .padding()
            //    .background(Color(red: colorNum, green: colorNum, blue: colorNum))
           //     .cornerRadius(5.0)
            //    .padding(.bottom, 20)
            //    .textContentType(.newPassword)
            RegisterButton(first_name: first_name, last_name: last_name, username: username, email: email, password: password)
            
            
            
            }.padding()
            Spacer()
            
        }
        
    }
    
    
    
}

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
    
    func addUserHandler(res: Bool, error: String) -> () {
        // TODO Change this name and make this the return handler of login
        if (res) {
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                defaults.setValue(username, forKey: "currUsername")
                defaults.setValue(password, forKey: "currPassword")
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
