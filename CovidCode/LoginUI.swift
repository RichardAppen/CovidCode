//
//  ContentView.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import SwiftUI

let colorNum: Double = 235.0/255.0
struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack() {
            CovidLogo()
            Spacer()
            TextField("Username", text: $username)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(red: colorNum, green: colorNum, blue: colorNum))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            LoginButton(username: username, password: password)
            Button(action: {
                let contentView = RegisterUI()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }) {
                Text("Create an Account")
                
            }
            Spacer()
        }
        .padding()
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
    
    var body: some View {
        Button(action: {
            NetworkLogin.loginUser(username: username, password: password, handler: userloginHandler)
        }) {
            Text("Login")
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(username.isEmpty || password.isEmpty || password.count < 8 )
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
              }
    }
    
    func userloginHandler(res: Bool, error: String) -> () {
        
        if (res) {
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(username, forKey: username)
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
