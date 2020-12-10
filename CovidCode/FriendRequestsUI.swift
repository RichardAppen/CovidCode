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
        VStack {
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
            HStack {
                Spacer()
                Text("New Requests")
                    .font(.system(size: 32, weight: .regular))
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Color(red: 119/255, green: 158/255, blue: 203/255))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    //.padding(.top, -60)
                    //.disableAutocorrection(true)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                                }
                            }
                        }
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32, weight: .regular))
                            .foregroundColor(Color(UIColor.systemGreen))
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notice"), message: Text("The user and you are now friends!"), dismissButton: .default(Text("Confirm")))
                    }
                    
                    DenyRequestButton(type: "x", friend: key, incFriendDictionary: $incFriendDictionary)
                    
                    
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
        
    
        
    }
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        incFriendDictionary = friendsDict
    }
    
    
    func addFriendHandler(status: Bool, res: String ) {
        if (status) {
            if (res == "True") {
                errorMsg = "You user and you are now friends!"
                
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


struct DenyRequestButton: View {
    
    var type: String
    var friend: String
    @Binding var incFriendDictionary: [String: String]
    @State var confirmAlert = true
    @State var showingAlert = false
    @State var errorMsg = ""
    
    var body: some View {
        
        Button(action: {
            self.showingAlert = true
            
        }) {
            if (type=="trashcan") {
                Image(systemName: "trash.circle.fill").font(.system(size: 23, weight: .regular)).foregroundColor(.black)
            } else if (type == "x") {
                Image(systemName: "xmark.circle.fill").font(.system(size: 32, weight: .regular)).foregroundColor(.red)
            }
            
        }
        
        .alert(isPresented: $showingAlert) {
            if (confirmAlert) {
                return Alert(title: Text("Important"), message: Text("Are you sure you would like to deny " + friend + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: friend.lowercased(), handler: removeFriendHandler)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                            }
                        }
                    }
                }, secondaryButton: .cancel())
                
            } else {
                
                return Alert(title: Text("Notice"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")) {
                    confirmAlert = true
                })
                
            }
        }
        
        
        
        
    }
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        incFriendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
    }
}


struct FriendRequestsUI_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsUI()
    }
}
