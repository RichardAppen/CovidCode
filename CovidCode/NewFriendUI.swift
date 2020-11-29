//
//  NewFriendUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI

struct NewFriendUI: View {
    //@State private var friendStatus: Bool = false
    @State private var friendName: String = ""
    @State private var showingAlert = false
    @State private var errorMsg: String = ""
    var parentTabController: TabControllerUI

    var body: some View {
        GeometryReader { geometry in
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
                        Image(systemName: "chevron.left").font(.system(size: 16, weight: .regular))
                    }
                    .padding()
                    Spacer()
                }
                HStack {
                    Text("Add Friend")
                }
            }
            Divider()
            
            //TODO This should tell the user if the firend is not in network?? Just to give extra info
            /*if (friendStatus) {
                Text("Friend cannot be located").foregroundColor(Color.red)
            } else {
                Text("Friend cannot be located").foregroundColor(Color.red).hidden()
            }*/
            TextField("Friend Name", text: $friendName)
                .padding()
                .background(Color(red: 235/255, green: 235/255, blue: 235/255))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
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
                
            }
            .frame(width: geometry.size.width / 1.1)
            .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Notice"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
                  }
            Spacer()
            Button(action: {
                DispatchQueue.main.async {
                    let contentView = parentTabController
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }

                
            }) {
                Text("Back to Friends List")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
                
            }
            .buttonStyle(PlainButtonStyle())
            
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

