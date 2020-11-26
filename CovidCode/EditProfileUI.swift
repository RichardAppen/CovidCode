//
//  EditProfileUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/26/20.
//

import Foundation
import SwiftUI

struct EditProfileUI: View {
    @State var name: String = ""
    @State var bio: String = ""
    var parentTabController: TabControllerUI
    
    var body: some View {
        
        VStack (){
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
                    Text("Edit Profile")
                }
            }
            Divider()
            
        
        Form{
            TextField("Name", text: $name )
            Button(action: {
                print("Name Updated!")
                
            }) {
                Text("Update Name").foregroundColor(.green)
            }
            
        }.frame(height: 120)
            
        Form{
            TextField("Bio", text: $bio )
            Button(action: {
                print("Bio Updated!")
            }) {
                Text("Update Bio").foregroundColor(.green)
            }
        }
        }
        
       // Spacer(minLength: 30)
    }
}

