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
    
    var body: some View {
        NavigationView {
        VStack (){
            
        
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Edit Profile").font(.headline)
        
                }
            }
        }
        
    }
}

