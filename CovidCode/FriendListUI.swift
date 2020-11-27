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
}

struct FriendListUI: View {
    var parentTabController: TabControllerUI
    @State var friendDictionary: [String: String] = [:]
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .offset(y: geometry.frame(in: .global).minY/9)
                    .frame(width: geometry.size.width, height: geometry.size.height*4)
                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                    .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopFriendListView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            
            
            VStack {
                ForEach(friendDictionary.sorted { $0.key > $1.key }, id: \.key) { key, value in
                    Section(header: determineCurrentLetter(currName: key).frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .leading).background(Color(red: 119/255, green: 158/255, blue: 203/255))) {
                    
                    }
                    HStack {
        
                        Section(header: Text(key)) {
                            Spacer()
                            if (Int(value) == 0) {
                                Image(systemName: "burn").font(.system(size: 23, weight: .regular)).foregroundColor(Color(UIColor.systemRed))
                            } else {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
                            }
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
        
    }
    
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict
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


struct TopFriendListView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("Friends")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
               
        
        }
    }
}

