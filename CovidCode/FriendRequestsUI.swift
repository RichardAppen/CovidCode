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
            HStack {
                Spacer()
                Text("New Requests")
                    .font(.system(size: 32, weight: .regular))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Color(red: 119/255, green: 158/255, blue: 203/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.top, -60)
                    .disableAutocorrection(true)
                Spacer()
            }
            
            ForEach(incFriendDictionary.sorted(by: >), id: \.key) {
                key, value in
                
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
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(Color(UIColor.systemGreen))
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notice"), message: Text("The user has been added and you are now mutual friends!"), dismissButton: .default(Text("Confirm")))
                    }
                    
                    RemoveFriendButton(type: "x", friend: key)
                    
                    
                }
                .padding(.vertical, 20)
                .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                .cornerRadius(5.0)
                .padding(.vertical, 20)
                
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
