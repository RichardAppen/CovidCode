//
//  FriendListUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI

class dataHolder {
    static var currLetter : String = "A"
    static var letterChecker : String = "A"
}


struct FriendListUI: View {
    @State var friendDictionary: [String: String] = [:]
    @State private var searchName: String = ""
    
    /*@State var alertMsg: String = ""
     @State var showingConfirmAlert = false
     @State var showingMessageAlert = false
     @State var errorMsg = ""*/
    @State var confirmAlert = true
    @State var showingAlert = false
    @State var errorMsg = ""
    
    
    
    var body: some View {
        
        ScrollView {
            
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        .offset(y: geometry.frame(in: .global).minY)
                        .frame(width: geometry.size.width, height: geometry.size.height*4)
                    
                    
                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                        .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopFriendListView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            
            VStack {
                
                HStack {
                    Image(systemName: "magnifyingglass").font(.system(size: 20, weight: .regular)).padding(.leading)
                    TextField("Search", text: $searchName)
                        .padding(6)
                        .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                        .cornerRadius(5.0)
                        .padding(.trailing)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                }.padding()
                
                ForEach(friendDictionary.sorted { $0.key < $1.key }.filter({
                    if (searchName == "") {
                        return true
                    }
                    return $0.key.contains(searchName)
                    
                    
                }), id: \.key) { key, value in
                    if (needNewLetter(currName: key)) {
                        Section(header: determineCurrentLetter(currName: key).frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .leading).background(Color(red: 119/255, green: 158/255, blue: 203/255))) {
                            
                        }
                    } else {
                        Divider().frame(height: 2).background(Color(UIColor.lightGray)).padding(.leading).padding(.trailing)
                    }
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
                        RemoveFriendButton(type: "trashcan", friend: key, friendDictionary: $friendDictionary)
                        /* Button(action: {
                         self.showingAlert = true
                         
                         }) {
                         
                         Image(systemName: "trash.circle.fill").font(.system(size: 23, weight: .regular)).foregroundColor(.black)
                         
                         
                         }
                         
                         .alert(isPresented: $showingAlert) {
                         if (confirmAlert) {
                         return Alert(title: Text("Important"), message: Text("Are you sure you would like to remove " + key + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                         let defaults = UserDefaults.standard
                         if let currUsername = defaults.string(forKey: "currUsername") {
                         if let currPassword = defaults.string(forKey: "currPassword") {
                         NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: key.lowercased(), handler: removeFriendHandler)
                         
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
                         }*/
                        
                        
                        
                    }.padding()
                   
                }
                
            }.onAppear {
                let defaults = UserDefaults.standard
                if let currUsername = defaults.string(forKey: "currUsername") {
                    if let currPassword = defaults.string(forKey: "currPassword") {
                        print("IN FRIENDS LIST BEFORE GET FRIENDS CALL")
                        print(currUsername)
                        print(currPassword)
                        NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
                        
                    }
                }
                
            }
            
            
        }
        /*.navigationBarTitle("")
         .navigationBarHidden(true)
         }
         .navigationBarTitle("")
         .navigationBarHidden(true)*/
        
        
    }
    
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
    }
    
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    
    
    private func needNewLetter(currName: String) -> Bool {
        let currNameUpper = currName.uppercased()
        let capitalAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        if (searchName != "") {
            return false
        }
        
        for item in capitalAlphabet {
            
            if (currNameUpper.hasPrefix(item) && dataHolder.letterChecker != item) {
                dataHolder.letterChecker = item
                return true
            }
        }
        
        return false
    }
    
    private func determineCurrentLetter(currName: String) -> Text {
        let currNameUpper = currName.uppercased()
        let capitalAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        
        for item in capitalAlphabet {
            
            if (currNameUpper.hasPrefix(item) && dataHolder.currLetter != item) {
                dataHolder.currLetter = item
                return Text("    " + item).foregroundColor(.white).fontWeight(.bold)
            }
        }
        
        return Text("")
    }
    
    
}

struct RemoveFriendButton: View {
    
    var type: String
    var friend: String
    @Binding var friendDictionary: [String: String]
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
                return Alert(title: Text("Important"), message: Text("Are you sure you would like to remove " + friend + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: friend.lowercased(), handler: removeFriendHandler)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
    func removeFriendHandler(res: Bool, error: String) -> () {
        
        errorMsg = error
        confirmAlert = false
        showingAlert = true
        
    }
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 > -1}
    }
}




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
                
                /*Button(action: {
                 let contentView = NewFriendUI(parentTabController: parentTabController)
                 if let window = UIApplication.shared.windows.first {
                 window.rootViewController = UIHostingController(rootView: contentView)
                 window.makeKeyAndVisible()
                 }
                 }) {
                 Image(systemName: "plus.circle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                 
                 }*/
                Button(action: {
                    let contentView = FriendRequestsUI()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    if (incFriendRequests) {
                        Image(systemName: "envelope.badge.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                    } else {
                        Image(systemName: "envelope.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                    }
                }
                /*NavigationLink(destination: FriendRequestsUI()) {
                 
                 if (incFriendRequests) {
                 Image(systemName: "envelope.badge.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                 } else {
                 Image(systemName: "envelope.fill").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                 }
                 }*/
                Spacer()
                Button(action: {
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
                            print("IN FRIENDS LIST BEFORE GET FRIENDS CALL")
                            print(currUsername)
                            print(currPassword)
                            NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                            
                        }
                    }
                    
                }
                
                /* NavigationLink(destination: NewFriendUI()) {
                 Image(systemName: "person.crop.circle.badge.plus").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                 }.onAppear(){
                 let defaults = UserDefaults.standard
                 if let currUsername = defaults.string(forKey: "currUsername") {
                 if let currPassword = defaults.string(forKey: "currPassword") {
                 print("IN FRIENDS LIST BEFORE GET FRIENDS CALL")
                 print(currUsername)
                 print(currPassword)
                 NetworkGetIncomingFriends.getIncomingFriends(username: currUsername, password: currPassword, handler: getIncomingFriendsHandler)
                 
                 }
                 }
                 
                 }*/
                
                
            }
            
            
        }
    }
    
    func getIncomingFriendsHandler(friendsDict: [String: String]) {
        if (friendsDict.count == 0) {
            incFriendRequests = false
        } else {
            incFriendRequests = true
        }
    }
    
    
}

