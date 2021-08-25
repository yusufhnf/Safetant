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
    private var initialHR = 0.0
    private var drivingHR = 0.0
    private var drowsyHR = 0.0
    private var lastHR = 0.0
    
    var delegate: HKWorkoutSessionDelegate!
    
    @IBOutlet weak var drivingIcon: WKInterfaceImage!
    @IBOutlet weak var heartRateIcon: WKInterfaceImage!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var actionButton: WKInterfaceButton!
    
    private var isDowny = false
    private var isPassDrivingHR = false
    private var heartRateQuery : HKQuery?
    
    
    
    @IBAction func actionPressed() {
        if isDowny {
            isDowny = false
            isPassDrivingHR = false
            updateUi()
        }else{
            pop()
        }
    }
    
    override func awake(withContext context: Any?) {
        autorizeHealthKit()
    }
    
    override func willActivate() {
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    override func didDeactivate() {
        stopHeartRateQuery()
    }
    
    func autorizeHealthKit() {
        
        // Used to define the identifiers that create quantity type objects.
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        // Requests permission to save and read the specified data types.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
    
        // cycle and value assignment
        for sample in samples {
            if type == .heartRate {
                lastHR = sample.quantity.doubleValue(for: heartRateQuantity)
            }
        }
        checkHeartRate(lastHeartRate: self.lastHR)
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
        
        self.heartRateQuery = query
        
        // query execution
        healthStore.execute(query)
    }
    
    func stopHeartRateQuery() {
        
        if let query  = self.heartRateQuery {
            healthStore.stop(query)
        }
    }
    
    func updateUi(){
        if self.isDowny {
            drivingIcon.setImage(UIImage(systemName: "eye"))
            heartRateIcon.setHidden(true)
            heartRateLabel.setText("Wake Up!")
            heartRateLabel.setTextColor(.red)
            actionButton.setTitle("Dismiss")
        }
        else {
            drivingIcon.setImage(UIImage(systemName: "car"))
            heartRateIcon.setHidden(false)
            heartRateLabel.setText("\(Int(lastHR))Bpm")
            heartRateLabel.setTextColor(.white)
            actionButton.setTitle("Exit Driving Mode")
        }
    }
    
    func checkHeartRate(lastHeartRate: Double) {
        let drivingTreshold = 109.3 / 100
        let drowsyTreshold = 93.0 / 100
        
        if initialHR == 0 {
            initialHR = lastHeartRate
            drivingHR = drivingTreshold * initialHR
            drowsyHR = drowsyTreshold * drivingHR
            print("drowsyHR \(drowsyHR)")
            print("initialHR \(initialHR)")
            print("drivingHR \(drivingHR)")

        }
        
        if lastHeartRate >= drivingHR  {
            isPassDrivingHR = true
        }
        
        if (lastHeartRate < drowsyHR) && isPassDrivingHR {
            print("Bangun bangun")
            WKInterfaceDevice.current().play(.notification)
            isDowny = true
        }
        updateUi()

    }
    
}
