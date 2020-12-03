//
//  FriendRequestsUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 12/3/20.
//

import SwiftUI

struct FriendRequestsUI: View {
    @State var incFriendDictionary: [String: String] = [:]
    @State private var showingAlert = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        NavigationView {
        VStack {
            
            ForEach(incFriendDictionary.sorted(by: >), id: \.key) {
                key, value in
                Divider().frame(height: 2).background(Color(UIColor.lightGray)).padding(.leading).padding(.trailing)
                HStack {
                    Spacer()
                    Text(key).font(.system(size: 32, weight: .regular))
                    Spacer()
                    
                    Button(action: {
                        
                        let defaults = UserDefaults.standard
                        
                        if let currUsername = defaults.string(forKey: "currUsername") {
                            if let currPassword = defaults.string(forKey: "currPassword") {
                                NetworkAddFriend.addFriend(username: currUsername, password: currPassword, friend: key.lowercased(), handler: addFriendHandler)
                            }
                        }
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 23, weight: .regular))
                            .foregroundColor(Color(UIColor.systemGreen))
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notice"), message: Text("The user has been added and you are now mutual friends!"), dismissButton: .default(Text("Confirm")))
                    }
                    
                    RemoveFriendButton(friend: key)
                    Spacer()
                }
            }
            Spacer()
        }.onAppear {
            let defaults = UserDefaults.standard
            if let currUsername = defaults.string(forKey: "currUsername") {
                if let currPassword = defaults.string(forKey: "currPassword") {
                    print("IN FRIENDS LIST BEFORE GET FRIENDS CALL")
                    print(currUsername)
                    print(currPassword)
                    NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                    
                }
            }
        
        }
        
    }.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Incoming Requests").font(.headline)
                    
                }
            }
        }
        
    }
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        incFriendDictionary = friendsDict
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

struct FriendRequestsUI_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsUI()
    }
}
