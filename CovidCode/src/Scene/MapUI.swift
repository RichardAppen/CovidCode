//
//  MapUI.swift
//  CovidCode
//
//  Created by Daniel Walder on 11/26/20.
//
//  MapUI instantiates a google heatmap instance as well as creates the header on top
//

import Foundation
import SwiftUI
import MapKit
import GoogleMaps
import GoogleMapsUtils

// Adds a header to the actual MapUI
struct MapWrapperUI: View {
    var parentTabViewController: TabControllerUI
    @Binding var loadingMap: Bool
    
    // For loading icon
    @State private var isAnimating = false
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack {
            // Use a ZStack to layer the header on top of the actual map
            ZStack {
                // If we are still loading the information that populates the map display the loading icon
                if (loadingMap) {
                    VStack {
                        Image(systemName: "burn")
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear { self.isAnimating = true }
                            .onDisappear { self.isAnimating = false }
                            .font(.system(size: 23, weight: .regular))
                        Text("Loading...").padding(.top)
                    }
                // Else generate the actual heat map
                } else {
                    MapUI(parentTabController: parentTabViewController)
                }
            
                VStack {
                    
                    LazyVStack {
                        
                        // Extension View : Paralax Header
                        Header()
                        
                        // Exention View
                        TopMapView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

// This is the actual MapUI which creates a ViewController for the heatmap system
struct MapUI: UIViewControllerRepresentable {
    
    var parentTabController: TabControllerUI
    
    // Make the heatmap
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapUI>) -> Heatmap {
        let heatmap = Heatmap()
        return heatmap
    }
    
    func updateUIViewController(_ uiViewController: Heatmap, context: UIViewControllerRepresentableContext<MapUI>) {
    
    }
    
}


// EXTENSION VIEW : An addition to the parallax header that gives the map a refresh button
struct TopMapView: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Map")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                    // When refresh is clicked reload the entire tab view which recreates the heatmap
                    let defaults = UserDefaults.standard
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        
                        let contentView = TabControllerUI(selectedTab: 1, username: currUsername)
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }
                }) {
                    Image(systemName: "arrow.clockwise.circle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                }
            }
        }
    }
}

