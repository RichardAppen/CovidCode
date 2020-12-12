//
//  FriendListUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//
//  Displays all the user's friend in a list. Allows the user to search for friends dynamically updating the view
//

import Foundation
import SwiftUI

// Object to hold current letter during a search that is constantly updating the view
class dataHolder {
    static var currLetter : String = "A"
    static var letterChecker : String = "A"
}


struct FriendListUI: View {
    
    @State var friendDictionary: [String: String] = [:]
    @State private var searchName: String = ""
    @State var confirmAlert = true
    @State var showingAlert = false
    @State var errorMsg = ""
    @State var loading = false
    
    // For the animated loading icon
    @State private var isAnimating = false
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
    }
    
    
    
    var body: some View {
        
        ScrollView {
            
            // EXTENSION VIEW : blue parallax header
            Header()
            // EXTENSION VIEW
            TopFriendListView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            
            VStack {
                
                // Search bar - search for specific friends in the list
                HStack {
                    Image(systemName: "magnifyingglass").font(.system(size: 20, weight: .regular)).padding(.leading)
                    TextField("Search", text: $searchName)
                        .padding(6)
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(5.0)
                        .padding(.trailing)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .disableAutocorrection(true)
                }.padding()
                
                // If we are still loading the friends list display the loading icon
                if (loading) {
                        VStack {
                        Image(systemName: "burn")
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear { self.isAnimating = true }
                            .onDisappear { self.isAnimating = false }
                            .font(.system(size: 23, weight: .regular))
                            Text("Loading...").padding(.top)
                        }
                            
                // If we have loaded the list of friends, display them
                } else {
                    // Determine which friends from the list to display (if not all)
                    ForEach(friendDictionary.sorted { $0.key < $1.key }.filter({
                        if (searchName == "") {
                            // display all friends if there is nothing in the search bar
                            return true
                        }
                        
                        // Only display the friends that contain the string in the search bar
                        return $0.key.contains(searchName)
                        
                    
                    }), id: \.key) { key, value in
                        // Determine if the friend list needs a new header (in the case where the upcoming name is the first name to start with a not yet seen first letter
                        if (needNewLetter(currName: key)) {
                            Section(header: determineCurrentLetter(currName: key).frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .leading).background(Color(red: 119/255, green: 158/255, blue: 203/255))) {
                                
                            }
                        // If we have already seen a name with this first letter then display a divider rather than a header
                        } else {
                            Divider().frame(height: 2).background(Color(UIColor.lightGray)).padding(.leading).padding(.trailing)
                        }
                        
                        // Display a covid risk icon depending on the friends risk level
                        HStack {
                            
                            Text(key)
                            Spacer()
                            if (Int(value) == 3) {
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(UIColor.systemRed))
                            } else if (Int(value) == 2){
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(UIColor.systemYellow))
                            } else if (Int(value) == 1){
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
                            } else {
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(.black))
                            }
                            
                            // EXTENSION VIEW
                            RemoveFriendButton(type: "trashcan", friend: key, friendDictionary: $friendDictionary)
                        }.padding()
                       
                    }
                }
                
                
            }.onAppear {
                let defaults = UserDefaults.standard
                if let currUsername = defaults.string(forKey: "currUsername") {
                    if let currPassword = defaults.string(forKey: "currPassword") {
                        
                        // Tell the friends list that we are loading the friends
                        loading = true
                        
                        // Network function to load all the friends
                        NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
                        
                    }
                }
            }
        }
    }
    
    // HANDLER : For the network function that is getting the list of friends
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
        
        // Comunicate with the view that we have gotten the friends
        loading = false
    }
    
    // HANDLER : for the network function of removing a friend from the list
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    
    
    // Determine if we need a new header for the friends list (think of an address book)
    private func needNewLetter(currName: String) -> Bool {
        let currNameUpper = currName.uppercased()
        let capitalAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        // If we are searching for a string don't continue with this function
        if (searchName != "") {
            return false
        }
        
       
        for item in capitalAlphabet {
            
            // Check the last letter used from our special object declared at the beginning
            if (currNameUpper.hasPrefix(item) && dataHolder.letterChecker != item) {
                dataHolder.letterChecker = item
                return true
            }
        }
        
        return false
    }
    
    // Determine the last letter used for a header (think address book)
    private func determineCurrentLetter(currName: String) -> Text {
        let currNameUpper = currName.uppercased()
        let capitalAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        
        for item in capitalAlphabet {
            
            // Check the last letter used from our special object declared at the beginning
            if (currNameUpper.hasPrefix(item) && dataHolder.currLetter != item) {
                dataHolder.currLetter = item
                return Text("    " + item).foregroundColor(.white).fontWeight(.bold)
            }
        }
        
        return Text("")
    }
    
    
}

// EXTENSION VIEW : Remove a friend from your friend's list
struct RemoveFriendButton: View {
    
    var type: String
    var friend: String
    @Binding var friendDictionary: [String: String]
    @State var confirmAlert = true
    @State var showingAlert = false
    @State var errorMsg = ""
    
    var body: some View {
        
        Button(action: {
            // display an alert for the action
            self.showingAlert = true
            
        }) {
            if (type=="trashcan") {
                Image(systemName: "trash.circle.fill").font(.system(size: 23, weight: .regular)).foregroundColor(.black)
            } else if (type == "x") {
                Image(systemName: "xmark.circle.fill").font(.system(size: 32, weight: .regular)).foregroundColor(.red)
            }
            
        }
        .alert(isPresented: $showingAlert) {
            // ConfirmAlert determines what happens
            if (confirmAlert) {
                return Alert(title: Text("Important"), message: Text("Are you sure you would like to remove " + friend + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            
                            // Network function to remove a friend from the list
                            NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: friend.lowercased(), handler: removeFriendHandler)
                            
                            // Then after this update the friend list again
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                // Network function to get a list of the user's friends
                                NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
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
    
    // HANDLER : for the network function of removing a friend
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    
    // HANDLER : for the network function of getting a list of friends
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
    }
}

// EXTENSION VIEW : An addition to the blue parallax header that adds a button for friend request and to add a new friend
struct TopFriendListView: View {
    @State var incFriendRequests: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Friends")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    
                    // If we click on the friend requst button go to the FriendRquestUI
                    let contentView = FriendRequestsUI()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    
                    // If there are any incoming friend request change what the image is
                    if (incFriendRequests) {
                        Image(systemName: "envelope.badge.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                    } else {
                        Image(systemName: "envelope.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                    }
                }
                Spacer()
                Button(action: {
                    
                    // If we click on the new friend button go to the newFriendUI
                    let contentView = NewFriendUI()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                }.onAppear(){
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            // Network function to get if there are incoming friends for the user
                            NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                            
                        }
                    }
                }
            }
        }
    }
    
    // HANDLER : for the network function of getting the user's incoming friend request
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        if (friendsDict.count == 0) {
            incFriendRequests = false
        } else {
            incFriendRequests = true
        }
    }
    
    
}

