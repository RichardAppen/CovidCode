//
//  HeatMapViewController.swift
//  CovidCode
//
//  Created by Daniel Walder on 11/26/20.
//
 
import UIKit
import GoogleMaps
import GoogleMapsUtils

class Heatmap: UIViewController {

  private var mapView: GMSMapView!
  private var heatmapLayer: GMUHeatmapTileLayer!

    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -37.1886, longitude: 145.708, zoom: 6.0)
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

