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
        
       NavigationView {
            GeometryReader { geometry in
                VStack() {
                    TextField("Friend Name", text: $friendName)
                        .padding()
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        //.padding(.top, -60)
                        .frame(width: geometry.size.width / 1.1)
                        .disableAutocorrection(true)
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
       .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Add Friend").font(.headline)
                    
                }
            }
        }
        
       
    }
        
    
    func addFriendHandler(status: Bool, res: String ) {
        if (status) {
            if (res == "True") {
                errorMsg = "The user has been added and you are now mutual friends!"
                
            } else {
                errorMsg = "The user has been added. Tell them to add you back to become mututal friends!"
                
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


