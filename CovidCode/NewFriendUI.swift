//
//  NewFriendUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI

struct NewFriendUI: View {
    @State private var friendStatus: Bool = false
    @State private var friendName: String = ""
    var parentTabController: TabControllerUI

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        let contentView = parentTabController
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Text("Back").padding()
                    }
                    Spacer()
                }
                HStack {
                    Text("Add Friend")
                }
            }
            Divider()
            
            //TODO This should tell the user if the firend is not in network?? Just to give extra info
            if (friendStatus) {
                Text("Friend cannot be located").foregroundColor(Color.red)
            } else {
                Text("Friend cannot be located").foregroundColor(Color.red).hidden()
            }
            TextField("Friend Name", text: $friendName).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            Button(action: {
                let defaults = UserDefaults.standard
                if let currUsername = defaults.string(forKey: "currUsername") {
                    if let currPassword = defaults.string(forKey: "currPassword") {
                        NetworkAddFriend.addFriend(username: currUsername, password: currPassword, friend: friendName, handler: addFriendHandler)
                    }
                }
            }) {
                Text("Add").padding()
            }.background(RoundedRectangle(cornerRadius: 40).opacity(0.1))
            Spacer()
        }
    }
    
    func addFriendHandler(status: Bool) {
        if (status) {
            let contentView = FriendListUI(parentTabController: parentTabController)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: contentView)
                window.makeKeyAndVisible()
            }
        } else {
            friendStatus = true
        }
    }


}

