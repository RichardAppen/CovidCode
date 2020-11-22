//
//  FriendListUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI


struct FriendListUI: View {
    var parentTabController: TabControllerUI
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                }
                HStack {
                    Text("Friends")
                }
                HStack {
                    Spacer()
                    Button(action: {
                        let contentView = NewFriendUI(parentTabController: parentTabController)
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .padding()
                    }
                }
            }
            Divider()
            List {
                // Fill in the list
                /*ForEach(1...3, id: \.self) { number in
                    Text(String(number))
                }*/
            }
        }
    }
    
}
