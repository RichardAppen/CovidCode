//
//  NewFriendUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI

struct NewFriendUI: View {
    @State var incFriendDictionary: [String: String] = [:]
    @State private var friendName: String = ""
    @State private var showingAlert = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        
            GeometryReader { geometry in
                VStack() {
                    ZStack {
                        HStack {
                            Button(action: {
                                let defaults = UserDefaults.standard
                                if let currUsername = defaults.string(forKey: "currUsername") {
                                    
                                    let contentView = TabControllerUI(selectedTab: 3, username: currUsername)
                                    if let window = UIApplication.shared.windows.first {
                                        window.rootViewController = UIHostingController(rootView: contentView)
                                        window.makeKeyAndVisible()
                                    }
                                }
                            }) {
                                Text("Back").padding()
                            }
                            Spacer()
                        }
                        
                    }
                    Divider()
                    TextField("Friend Name", text: $friendName)
                        .padding()
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        //.padding(.top, -60)
                        .frame(width: geometry.size.width / 1.1)
                        .disableAutocorrection(true)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        
                        let defaults = UserDefaults.standard
                        
                        if (friendName.caseInsensitiveCompare(defaults.string(forKey: "currUsername") ?? "unknown") == .orderedSame) {
                            errorMsg = "You can not add yourself as a friend!"
                            showingAlert = true
                            return
                        }
                        if let currUsername = defaults.string(forKey: "currUsername") {
                            if let currPassword = defaults.string(forKey: "currPassword") {
                                NetworkAddFriend.addFriend(username: currUsername, password: currPassword, friend: friendName.lowercased(), handler: addFriendHandler)
                            }
                        }
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding(6)
                            .frame(width: geometry.size.width / 1.1)
                            .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notice"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
                    }
                    
                    
                 
                }
                .frame(maxWidth: UIScreen.main.bounds.width)
                
            }
            
        
       
    }
        
    
    func addFriendHandler(status: Bool, res: String ) {
        if (status) {
            if (res == "True") {
                errorMsg = "The user and you are now friends!"
                
            } else {
                errorMsg = "A friend request has been sent!"
                
            }
            showingAlert = true
            
        } else {
            errorMsg = res
            showingAlert = true
        }
    }
    
    
    
}

struct NewFriendUI_Previews: PreviewProvider {
    static var previews: some View {
        NewFriendUI()
    }
}


