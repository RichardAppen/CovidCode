//
//  ContentView.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import SwiftUI


struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
        VStack() {
            CovidLogo()
            Spacer()
            TextField("Username", text: $username)
                .padding()
                .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .frame(width: geometry.size.width / 1.1)
                .disableAutocorrection(true)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .frame(width: geometry.size.width / 1.1)
            LoginButton(username: username.lowercased(), password: password, geometry: geometry)
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
            let defaults = UserDefaults.standard
            if let currUsername = defaults.string(forKey: "currUsername") {
                username = currUsername
                if let currPassword = defaults.string(forKey: "currPassword") {
                    print(currUsername)
                    print(currPassword)
                    NetworkLogin.loginUser(username: currUsername, password: currPassword, handler: userloginHandler)
                }
            }
        }
    }
    }
    
    func userloginHandler(res: Bool, error: String, firstName: String?, lastName: String?) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                print("TESTING!!!!!!")
                let defaults = UserDefaults.standard
                //REMOVE THIS BLOCK
                var dateString = String(12) + "/" + String(5) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(4) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(2) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(1) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(5) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(30) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(29) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(28) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(27) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(26) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(24) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(23) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(22) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(21) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(20) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(19) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(18) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(17) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(16) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(15) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(13) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(12) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(11) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(10) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(9) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(8) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                
                if let first_name = firstName {
                    defaults.setValue(first_name, forKey: "firstName")
                }
                if let last_name = lastName {
                    defaults.setValue(last_name, forKey: "lastName")
                }
                let contentView = TabControllerUI(username: username)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }
        }
        
    }
}

struct CovidLogo: View {
    var body: some View {
        VStack {
            HStack {
                /*
                Image(systemName: "waveform.path.ecg").font(.system(size: 50, weight: .regular))
                Image(systemName: "bandage.fill").font(.system(size: 50, weight: .regular))
                */
                Image("qr-code")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
        }
    }
}


struct LoginButton: View {
    var username: String
    var password: String
    @State var errorMsg: String = ""
    @State private var showingAlert = false
    var geometry: GeometryProxy
    
    var body: some View {
        Button(action: {
            
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
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
              }
    }
    
    func userloginHandler(res: Bool, error: String, firstName: String?, lastName: String?) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                
                //REMOVE THIS BLOCK
                var dateString = String(12) + "/" + String(5) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(4) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(2) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(1) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(12) + "/" + String(5) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(30) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(29) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(28) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(27) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(26) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(24) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(23) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(22) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(21) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(20) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(19) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(18) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(17) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(16) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(15) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(13) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(12) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(11) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(10) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(9) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                dateString = String(11) + "/" + String(8) + "/" + String(2020)
                defaults.set("1", forKey: dateString)
                defaults.setValue(username, forKey: "currUsername")
                defaults.setValue(password, forKey: "currPassword")
                if let first_name = firstName {
                    defaults.setValue(first_name, forKey: "firstName")
                }
                if let last_name = lastName {
                    defaults.setValue(last_name, forKey: "lastName")
                }
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
