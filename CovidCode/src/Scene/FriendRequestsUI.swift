//
//  FriendRequestsUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 12/3/20.
//
//  Page for the user to look at who wants to be their friend
//

import SwiftUI

struct FriendRequestsUI: View {
    @State var incFriendDictionary: [String: String] = [:]
    @State private var showingAlert = false
    @State private var errorMsg: String = ""
    
    var body: some View {
        VStack {
            // HEADER
            ZStack {
                // Back Button
                HStack {
                    Button(action: {
                        let defaults = UserDefaults.standard
                        if let currUsername = defaults.string(forKey: "currUsername") {
                            
                            // Goes back to friend list
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
            // END HEADER
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
                Spacer()
            }
            
            // Display all incoming friends in a list
            ForEach(incFriendDictionary.sorted(by: >), id: \.key) {
                key, value in
                
                HStack {
                    Spacer()
                    Text(key).font(.system(size: 32, weight: .regular))
                    Spacer()
                    
                    // Button to add the friend who made the request to the user
                    Button(action: {
                        
                        let defaults = UserDefaults.standard
                        
                        if let currUsername = defaults.string(forKey: "currUsername") {
                            if let currPassword = defaults.string(forKey: "currPassword") {
                                
                                // Network function of adding a new friend
                                NetworkAddFriend.addFriend(username: currUsername, password: currPassword, friend: key.lowercased(), handler: addFriendHandler)
                                
                                // Then once thats done update the incoming request friend list
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    
                                    // Network function of getting all incoming friends
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
                    
                    // EXTENSION VIEW
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
                    
                    // Network function of getting the incoming friend request
                    NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                    
                }
            }
        }
    }
    
    // HANDLER : for the network function of getting the incoming friend request
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        incFriendDictionary = friendsDict
    }
    
    // HANDLER : for the network function of adding a friend
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

// EXTENSION VIEW : button for the user to press that will deny an incoming friend request
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
            // ConfirmAlert tells what the alert will do
            if (confirmAlert) {
                return Alert(title: Text("Important"), message: Text("Are you sure you would like to deny " + friend + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            // Network function to remove a friend from the user's list of incoming friends
                            NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: friend.lowercased(), handler: removeFriendHandler)
                            
                            // After that is finished re-update the incoming friends list
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                // Netowrk function of getting the incoming friends
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
    
    // HANDLER : For the network function of removing a friend
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    
    // HANDLER : for the network fucntion of getting the incoming friend request list
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        incFriendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
    }
}


struct FriendRequestsUI_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsUI()
    }
}
