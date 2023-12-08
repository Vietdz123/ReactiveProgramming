//
//  HealthAppIntent.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//

import Foundation


import SwiftUI
import WidgetKit
import AppIntents


@available(iOS 17.0, *)
struct HealthConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "HealthConfigurationAppIntent"
    static var description = IntentDescription("This is an example widget.")
    
    // An example configurable parameter.
    @Parameter(title: "Pick a Health")
    var healthSrc: HealthSource
}

struct WaterIntent: AppIntent {

    init() {
        
    }
    
    static var title: LocalizedStringResource = "ButtonAppIntentWater"
    
    @Parameter(title: "Task ID Water")
    var id_name: String
    
    init(id_name: String) {
        self.id_name = id_name
    }
    
    func perform() async throws -> some IntentResult {
        HealthHelper().saveWaterIntakeToHealthKit()
        return .result()
    }

}

struct SleepIntent: AppIntent {

    init() {
        
    }
    
    static var title: LocalizedStringResource = "ButtonAppIntentSleep"
    
    @Parameter(title: "Task ID Sleep")
    var id_name: String
    
    init(id_name: String) {
        self.id_name = id_name
    }
    
    func perform() async throws -> some IntentResult {
        HealthHelper().saveSleepDataToHealthKit()
        return .result()
    }

}
