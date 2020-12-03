//
//  TabControllerUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//

import Foundation
import SwiftUI

struct TabControllerUI: View {
    
    @State private var showDetail = false
    @State var selectedTab = 0
    var username: String
    
    
    var body: some View {
        /*let selection = Binding<Int>(
             get: { self.selectedTab },
             set: { self.selectedTab = $0
                 print("Pressed tab: \($0)")
                 if $0 == 0 {
                    
                 }
         })*/
        
        
        TabView(selection: $selectedTab) {
            HomescreenUI(parentTabController: self, username: username)
             .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
              }
                .tag(0)
            Text("Map View")
                .tabItem {
                    Image(systemName: "mappin.and.ellipse").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemYellow))
                   Text("Map")
             }
                .tag(1)
            CalendarUI(parentTabController: self)
                .tabItem {
                    Image(systemName: "calendar").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemPink))
                   Text("Calender")
             }
                .tag(2)
            FriendListUI()
                .tabItem {
                    Image(systemName: "person.3").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
                   Text("Friends")
             }
                .tag(3)
            
        }.onAppear {
            //selectedTab = 0
        }
        //.accentColor(.purple)
        
            
    }



}
