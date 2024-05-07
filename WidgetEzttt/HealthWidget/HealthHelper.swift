//
//  HealthHelper.swift
//  WidgetEztttExtension
//
//  Created by Duc on 01/12/2023.
//

import SwiftUI
import HealthKit

enum HealthEnum: String, CaseIterable {
    
    case placeHolder 
    case steps
    case distance
    case sleepTime
    case energyBurn
    case waterTrack
    
    
    var nameId: String {
        return self.rawValue
    }
    
    static func getType(name: String) -> HealthEnum {
        
        for folderType in HealthEnum.allCases {
            if folderType.nameId == name {
                return folderType
            }
        }
        
        return .placeHolder
        
    }

}





class HealthHelper{
    let healthStore = HKHealthStore()
    
    func requestHealthKitAuthorization(onGrandted : @escaping () -> (),onDecline : @escaping () -> () ) {
       
      //  let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .heartRate)!] // Specify types you want to read access
        
        let writeTypes = Set(
            [
               HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
               HKObjectType.quantityType(forIdentifier: .dietaryWater)!
            ])
      
        let readTypes: Set<HKObjectType> = Set([
            //HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        ])
        
      
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    onGrandted()
                }
            } else {
                DispatchQueue.main.async {
                    onDecline()
                }
                // Authorization failed, handle the error
            }
        }
    }
    
    
    func fetchStepCount2222() async -> String {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return "0"
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withUnsafeContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                if let sum = result?.sumQuantity() {
                    let stepCount = sum.doubleValue(for: HKUnit.count())
                    continuation.resume(returning: String(format: "%.0f", stepCount))
                } else {
                    continuation.resume(returning: "0")
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func writeStepCountData() {
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let stepCountQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: 500)
        let stepCountSample = HKQuantitySample(type: quantityType, quantity: stepCountQuantity, start: Date(), end: Date())

        healthStore.save(stepCountSample) { (success, error) in
            if success {
                print("Health write data success")
            } else {
                print("Health write data failure")
            }
        }
    }
    
    
    func fetchWaterConsumption() async -> String {
        guard let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater) else {
            return "0"
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withUnsafeContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                if let sum = result?.sumQuantity() {
                    let waterConsumption = sum.doubleValue(for: HKUnit.literUnit(with: .milli))
                    continuation.resume(returning: String(format: "%.0f", waterConsumption / 29.57))
                } else {
                    continuation.resume(returning: "0")
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func saveWaterIntakeToHealthKit(volume: Double = 12 * 29.57) {
        // 1. Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }


        // 3. Define the dietary water type
        guard let dietaryWaterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            print("Dietary Water is not available.")
            return
        }


              
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: volume)
                let waterSample = HKQuantitySample(type: dietaryWaterType, quantity: waterQuantity,
                                                   start: Date(), end: Date())

             
                healthStore.save(waterSample) { (success, error) in
                    if success {
                        print("Water intake data saved to HealthKit.")
                    } else if let error = error {
                        print("Failed to save water intake data to HealthKit. Error: \(error.localizedDescription)")
                    }
                }
      
    }

    

    
    func fetchHeartRate() async -> String {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return "0"
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withUnsafeContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { (_, result, error) in
                if let average = result?.averageQuantity() {
                    let heartRate = average.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                    continuation.resume(returning: "\(heartRate)")
                } else {
                    continuation.resume(returning: "0")
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchEnergyBurned() async -> String {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return "0"
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withUnsafeContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
                if let sum = result?.sumQuantity() {
                    let energyBurned = sum.doubleValue(for: HKUnit.kilocalorie())
                    continuation.resume(returning: "\(energyBurned)")
                } else {
                    continuation.resume(returning: "0")
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchSleepDuration() async -> String {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return "0"
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return await withUnsafeContinuation { continuation in
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, samples, error) in
                guard let sleepSamples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: "0")
                    return
                }
                
                let sleepDuration = sleepSamples.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
                continuation.resume(returning: String(format: "%.0f", sleepDuration / 3600))
            }
            
            healthStore.execute(query)
        }
    }
    
    func saveSleepDataToHealthKit(duration: TimeInterval = 3600) {
        // 1. Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }

        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            print("Sleep Analysis is not available.")
            return
        }

                let startDate = Date()
                let endDate = startDate.addingTimeInterval(duration)
                let sleepSample = HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.inBed.rawValue,
                                                   start: startDate, end: endDate)

                // 6. Save the sleep sample to HealthKit
                healthStore.save(sleepSample) { (success, error) in
                    if success {
                        print("Sleep data saved to HealthKit.")
                    } else if let error = error {
                        print("Failed to save sleep data to HealthKit. Error: \(error.localizedDescription)")
                    }
                }
         
        
    }

}
