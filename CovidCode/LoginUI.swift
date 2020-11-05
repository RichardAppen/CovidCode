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
            LoginButton(username: username)
            Spacer()
        }
        .padding()
    }
}

struct CovidLogo: View {
    var body: some View {
        VStack {
            Text("CovidCode")
                .padding()
                .font(.largeTitle)
            HStack {
                // CURRENTLY TEMPORARY
                Image(systemName: "waveform.path.ecg").font(.system(size: 50, weight: .regular))
                Image(systemName: "bandage.fill").font(.system(size: 50, weight: .regular))
            }
            .padding()
        }
    }
}


struct LoginButton: View {
    var username: String
    var body: some View {
        Button(action: {
            let contentView = HomescreenUI(username: username)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: contentView)
                window.makeKeyAndVisible()
            }
        }) {
            Text("Login")
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(username.isEmpty)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
