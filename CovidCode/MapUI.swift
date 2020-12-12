//
//  MapUI.swift
//  CovidCode
//
//  Created by Daniel Walder on 11/26/20.
//



import SwiftUI
import MapKit
import GoogleMaps
import GoogleMapsUtils

struct MapUI: UIViewControllerRepresentable {
    
    var parentTabController: TabControllerUI
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MapUI>) -> Heatmap {
        let heatmap = Heatmap()
        return heatmap
    }
    
    func updateUIViewController(_ uiViewController: Heatmap, context: UIViewControllerRepresentableContext<MapUI>) {
    
    }
    
}

