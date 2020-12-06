//
//  CovidCodeApp.swift
//  CovidCode
//
//  Created by Richard Appen on 11/21/20.
//

import Foundation
import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBPyzAIpfsVE6ZtaevAnC2iDM1sxtMhgY0")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("in foreground")
        //function that gets covid risks from server
        //function that filters for high covid risks
        //function that writes risk's coordinates to json file
    }
}

@main
struct CovidCodeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
