//
//  TabControllerUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//
//  Creates 4 tabs and allows the user to switch between the tabs. Also deals with loading heatmap locations
//  from the server.
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
        
        // Main tab view that present each tab at the bottom of the screen
        TabView(selection: $selectedTab) {
            // Tab 0 leads to the HomescreenUI, and is opened by default
            HomescreenUI(parentTabController: self, username: username)
             .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
              }
                .tag(0)
            
            // Tab 1 leads to the MapUI which is contained in the MapWrapperUI
            MapWrapperUI(parentTabViewController: self, loadingMap: $loadingMap)
                .tabItem {
                    Image(systemName: "mappin.and.ellipse").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemYellow))
                   Text("Map")
             }
                .tag(1)
            
            // Tab 2 leads to the CalendarUI
            CalendarUI(parentTabController: self)
                .tabItem {
                    Image(systemName: "calendar").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemPink))
                   Text("Calender")
             }
                .tag(2)
            
            // Tab 3 leads to the FriendListUI
            FriendListUI()
                .tabItem {
                    Image(systemName: "person.3").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
                   Text("Friends")
             }
                .tag(3)
            
        }.onAppear {
            
            // When we load the tab view load up all the heatmap locations from the server
            loadingMap = true           // Make sure loadingMap is true until we are done
            
            // Network function to get all heatmap locations from the server
            NetworkGetLocations.getLocations(username: UserDefaults.standard.string(forKey: "currUsername") ?? "usernameError", password: UserDefaults.standard.string(forKey: "currPassword") ?? "passwordError", handler: getLocationsHandler)
        }
        
    }

    // HANDLER : for Network function to get lal heatmap locations
    func getLocationsHandler(locationdict: [String:String]) -> () {
        self.coords = locationdict      // heatmap locations are in String:String dictionary
        
        // Write the dictionary to a form accepted by Heatmap API
        var locations : [[String: Double]] = []
        for (key, value) in locationdict {
            if value == "3" {
                let coords = key.components(separatedBy: ",")
                locations.append(["lat":Double(coords[0])!, "lng":Double(coords[1])!])
            }
        }
        
        // Try and save the locations to the sampleRisks.json file
        do {
            try save(jsonObject: locations, toFilename: "sampleRisks.json")
        } catch {
            print("failed to write json")
        }
        
        // Once we are done we can make loadingMap false so the map view appears
        loadingMap = false
    }
    
    // function to save a jsonObject to a json file.
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

