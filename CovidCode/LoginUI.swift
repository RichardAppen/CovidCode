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
                        NetworkGetRisk.getRisk(username: currUsername, password: currPassword, handler: getRiskHandler)
                        NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
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
    func getRiskHandler(risk: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(risk, forKey: "risk")
        
    }
    func getFriendsHandler(friendsDict: [String: String]) {
        let defaults = UserDefaults.standard
        var highRiskFriendsCount = friendsDict.filter { key, value in return Int(value) ?? -1 == 3}.count
        defaults.setValue(highRiskFriendsCount, forKey: "highRiskFriendsCount")
        defaults.setValue(friendsDict.count, forKey: "friendsCount")
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
            NetworkGetRisk.getRisk(username: username, password: password, handler: getRiskHandler)
            NetworkGetFriends.getFriends(username: username, password: password, handler: getFriendsHandler)
            
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
    
    
    func getRiskHandler(risk: Int) {
        let defaults = UserDefaults.standard
        defaults.setValue(risk, forKey: "risk")
        
    }
    
    func getFriendsHandler(friendsDict: [String: String]) {
        let defaults = UserDefaults.standard
        var highRiskFriendsCount = friendsDict.filter { key, value in return Int(value) ?? -1 == 3}.count
        defaults.setValue(highRiskFriendsCount, forKey: "highRiskFriendsCount")
        defaults.setValue(friendsDict.count, forKey: "friendsCount")
    }
    func userloginHandler(res: Bool, error: String, firstName: String?, lastName: String?) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                
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
