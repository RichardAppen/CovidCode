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
    
    @State var alertMsg: String = ""
    
    @State var showingConfirmAlert = false
    @State var showingMessageAlert = false
    @State var errorMsg = ""
    
    var body: some View {
       
        NavigationView {
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
                        
                        Section(header: Text(key)) {
                            Spacer()
                            
                            if (Int(value) == 0) {
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(UIColor.systemRed))
                            } else {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
                            }
                            RemoveFriendButton(friend: key)
                            
                        }.padding()
                        
                    }
                }
                
            }.onAppear {
                let defaults = UserDefaults.standard
                if let currUsername = defaults.string(forKey: "currUsername") {
                    if let currPassword = defaults.string(forKey: "currPassword") {
                        NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
                        
                    }
                }
                
            }
           
            
        }
        .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        
    }
    
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict
    }
    
    func removeFriendHandler(res: Bool, error: String) -> () {

            errorMsg = error
            showingMessageAlert = true

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
    
    var friend: String
    @State var confirmAlert = true
    @State var showingAlert = false
    @State var errorMsg = ""
    
    var body: some View {
        
        Button(action: {
            self.showingAlert = true
            
        }) {
            Image(systemName: "trash.circle.fill").font(.system(size: 23, weight: .regular)).foregroundColor(.black)

        }
        
        .alert(isPresented: $showingAlert) {
            if (confirmAlert) {
                return Alert(title: Text("Important"), message: Text("Are you sure you would like to remove " + friend + " as a friend?"),  primaryButton: .destructive(Text("Remove")) {
                        let defaults = UserDefaults.standard
                        if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                        NetworkRemoveFriend.removeFriend(username: currUsername, password: currPassword, friend: friend.lowercased(), handler: removeFriendHandler)
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
}




struct TopFriendListView: View {
    
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
                NavigationLink(destination: NewFriendUI()) {
                    Image(systemName: "plus.circle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                }
            }
            
            
        }
    }
}

