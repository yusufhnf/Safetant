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

    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)

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
                heartRateLabel.setText("\(self.value) Bpm")
                
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

}
