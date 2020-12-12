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
        let camera = GMSCameraPosition.camera(withLatitude: 39.828560, longitude: -98.579287, zoom: 3.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        heatmapLayer = GMUHeatmapTileLayer()
        addHeatmap()
        heatmapLayer.map = mapView
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  func addHeatmap() {
    
    var object: [[String: Any]] = [[:]]
    do {
        try object = loadJSON(withFilename: "sampleRisks.json") as! [[String: Any]]
    } catch {
        print("failed to load json")
    }

    //print(object)
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
    heatmapLayer.radius = 50
    heatmapLayer.weightedData = list
  }
}

func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
