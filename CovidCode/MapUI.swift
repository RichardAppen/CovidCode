//
//  MapUI.swift
//  CovidCode
//
//  Created by Daniel Walder on 11/26/20.
//


import Foundation
import SwiftUI
import MapKit
import GoogleMaps
import GoogleMapsUtils

struct MapWrapperUI: View {
    var parentTabViewController: TabControllerUI
    @Binding var loadingMap: Bool
    @State private var isAnimating = false
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack {
            /*Button(action: {
                let defaults = UserDefaults.standard
                if let currUsername = defaults.string(forKey: "currUsername") {
                    
                    let contentView = TabControllerUI(selectedTab: 1, username: currUsername)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }
            }) {
                Text("Refresh").padding()
            }*/
            ZStack {
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
                } else {
                    MapUI(parentTabController: parentTabViewController)
                }
            /*ScrollView {
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .offset(y: geometry.frame(in: .global).minY/9)
                    .frame(width: geometry.size.width, height: geometry.size.height*4)
                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                    .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopMapView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                Spacer()
                Text("What")
            }.disabled(true)
            .frame(height: UIScreen.main.bounds.height / 9)*/
                VStack {
                    /*TopMapView().padding(.top).padding(.leading).padding(.trailing).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 6.5).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255))).ignoresSafeArea()*/
                    LazyVStack {
                    GeometryReader { geometry in
                        if geometry.frame(in: .global).minY <= 0 {
                            TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                            .offset(y: geometry.frame(in: .global).minY/9)
                            .frame(width: geometry.size.width, height: geometry.size.height*4)
                        } else {
                            TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                            .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                            .offset(y: -geometry.frame(in: .global).minY)
                        }
                    }
                    TopMapView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        Spacer()
                    }
                    Spacer()
                }
                
            
            
            }
            
        }
    }
    
    
    
}

struct MapUI: UIViewControllerRepresentable {
    
    var parentTabController: TabControllerUI
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapUI>) -> Heatmap {
        let heatmap = Heatmap()
        return heatmap
    }
    
    func updateUIViewController(_ uiViewController: Heatmap, context: UIViewControllerRepresentableContext<MapUI>) {
    
    }
    
}

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

