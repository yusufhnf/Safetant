//
//  InterfaceController.swift
//  Safetant WatchKit Extension
//
//  Created by Yusuf Umar Hanafi on 16/08/21.
//

import WatchKit
import Foundation
import HealthKit


class DrivingModeInterfaceController: WKInterfaceController {
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    private var value = 0
    private var initialHR = 0.0
    private var drivingHR = 0.0
    private var drowsyHR = 0.0
//    private var isSleepy = false
    
    var delegate: HKWorkoutSessionDelegate!
    
    @IBOutlet weak var drivingIcon: WKInterfaceImage!
    @IBOutlet weak var heartRateIcon: WKInterfaceImage!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var actionButton: WKInterfaceButton!
    
    
    @IBAction func actionPressed() {
        configure(isSleepy: false)
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
//        configure(isSleepy: true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func autorizeHealthKit() {
        
        // Used to define the identifiers that create quantity type objects.
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        // Requests permission to save and read the specified data types.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        // variable initialization
        var lastHeartRate = 0.0
        
        // cycle and value assignment
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
            print(lastHeartRate)
            heartRateLabel.setText("\(self.value) Bpm")
            
            checkHeartRate(lastHeartRate: lastHeartRate)
        }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // We want data points from our current device
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        
        // A query that returns changes to the HealthKit store, including a snapshot of new changes and continuous monitoring as a long-running query.
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // A sample that represents a quantity, including the value and the units.
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            
            self.process(samples, type: quantityTypeIdentifier)
            
        }
        
        // It provides us with both the ability to receive a snapshot of data, and then on subsequent calls, a snapshot of what has changed.
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // query execution
        healthStore.execute(query)
    }
    
    func configure(isSleepy: Bool){
        if isSleepy {
            drivingIcon.setImage(UIImage(systemName: "eye"))
            heartRateIcon.setHidden(true)
            heartRateLabel.setText("Wake Up!")
            heartRateLabel.setTextColor(.red)
            actionButton.setTitle("Dismiss")
        }
        else {
            drivingIcon.setImage(UIImage(systemName: "car"))
            heartRateIcon.setHidden(false)
            heartRateLabel.setText("\(value)Bpm")
            heartRateLabel.setTextColor(.white)
            actionButton.setTitle("Exit Driving Mode")
        }
    }
    
    func checkHeartRate(lastHeartRate: Double) {
        let drivingTreshold = 109.3 / 100
        let drowsyTreshold = 107.0 / 100
        
        if lastHeartRate < drowsyHR {
            print("Bangun bangun")
            configure(isSleepy: true)
        }
        if initialHR == 0 {
            initialHR = lastHeartRate
            drivingHR = drivingTreshold * initialHR
            drowsyHR = drowsyTreshold * initialHR
        }
    }
    
}
