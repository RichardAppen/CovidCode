//
//  HeatMapViewController.swift
//  CovidCode
//
//  Created by Daniel Walder on 11/26/20.
//
 
import UIKit
import GoogleMaps
import GoogleMapsUtils
import SwiftUI

class Heatmap: UIViewController {

  var mapView: GMSMapView!
  var heatmapLayer: GMUHeatmapTileLayer!
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 32.770994, longitude: -117.015391, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        heatmapLayer = GMUHeatmapTileLayer()
        getLocations()
        //addHeatmap()
        heatmapLayer.map = mapView
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()

  }
    
    func getLocations() {
        NetworkGetLocations.getLocations(username: UserDefaults.standard.string(forKey: "currUsername") ?? "usernameError", password: UserDefaults.standard.string(forKey: "currPassword") ?? "passwordError", handler: getLocationsHandler)
    }
    
    func getLocationsHandler(locationdict: [String:String]) -> () {
        var locations : [[String: Any]] = []
        for (key, value) in locationdict {
            print("key: " + key + " value: " + value)
            if value == "3" {
                let coords = key.components(separatedBy: ",")
                locations.append(["lat":Double(coords[0]), "lng":Double(coords[1])])
            }
        }
                
        var list = [GMUWeightedLatLng]()
        for item in locations {
          let lat = item["lat"] as! CLLocationDegrees
          let lng = item["lng"] as! CLLocationDegrees
          let coords = GMUWeightedLatLng(
            coordinate: CLLocationCoordinate2DMake(lat, lng),
            intensity: 1.0
          )
          list.append(coords)
        }
        
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
        heatmapLayer.clearTileCache()
    }

  func addHeatmap() {

    // Get the data: latitude/longitude positions of police stations.
    guard let path = Bundle.main.url(forResource: "sampleRisks", withExtension: "json") else {
      return
    }
    guard let data = try? Data(contentsOf: path) else {
      return
    }
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
      return
    }
    guard let object = json as? [[String: Any]] else {
      print("Could not read the JSON.")
      return
    }

    var list = [GMUWeightedLatLng]()
    for item in object {
      let lat = item["lat"] as! CLLocationDegrees
      let lng = item["lng"] as! CLLocationDegrees
      let coords = GMUWeightedLatLng(
        coordinate: CLLocationCoordinate2DMake(lat, lng),
        intensity: 1.0
      )
      list.append(coords)
    }

    // Add the latlngs to the heatmap layer.
    heatmapLayer.weightedData = list
  }
}

