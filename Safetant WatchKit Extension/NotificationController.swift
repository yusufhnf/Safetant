//
//  NotificationController.swift
//  Safetant WatchKit Extension
//
//  Created by Yusuf Umar Hanafi on 16/08/21.
//

import WatchKit
import Foundation
import UserNotifications

class NotificationController: WKUserNotificationInterfaceController {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var locationMap: WKInterfaceMap!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    
    var mapSpan: MKCoordinateSpan
    var coord: CLLocationCoordinate2D
    var lat: CLLocationDegrees
    var long: CLLocationDegrees
    
    override init() {
        // Initialize variables here.
        lat = -7.24917
        long = 112.75083
        mapSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        super.init()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
        titleLabel.setText("John Doe is in Emergency")
        timeLabel.setText("5m ago")
        locationMap.setRegion(MKCoordinateRegion(center: coord, span: mapSpan))
        locationMap.addAnnotation(coord, with: .red)
//        locationLabel.setText("Location: \(lat), \(long)")
        
    }
}
