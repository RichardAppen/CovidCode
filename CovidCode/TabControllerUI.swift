//
//  TabControllerUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//

import Foundation
import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct TabControllerUI: View {
    
    @State private var showDetail = false
    @State var selectedTab = 0
    @State var coords: [String:String] = [:]
    var username: String
    @State var loadingMap = false
    
    
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
            MapWrapperUI(parentTabViewController: self, loadingMap: $loadingMap)
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
            loadingMap = true
            NetworkGetLocations.getLocations(username: UserDefaults.standard.string(forKey: "currUsername") ?? "usernameError", password: UserDefaults.standard.string(forKey: "currPassword") ?? "passwordError", handler: getLocationsHandler)
        }
        //.accentColor(.purple)
        
    }


    func getLocationsHandler(locationdict: [String:String]) -> () {
        self.coords = locationdict
        
        //write to json file
        var locations : [[String: Double]] = []
        for (key, value) in locationdict {
            if value == "3" {
                let coords = key.components(separatedBy: ",")
                locations.append(["lat":Double(coords[0])!, "lng":Double(coords[1])!])
            }
        }
        print(locations)
        
        do {
            try save(jsonObject: locations, toFilename: "sampleRisks.json")
        } catch {
            print("failed to write json")
        }
        
        loadingMap = false
    }
    
    func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            if let url = urls.first {
                var fileURL = url.appendingPathComponent(filename)
                fileURL = fileURL.appendingPathExtension("json")
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
                try data.write(to: fileURL, options: [.atomicWrite])
                return true
            }
            
            return false
    }
}

