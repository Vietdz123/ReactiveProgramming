//
//  HealthProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//

import SwiftUI
import WidgetKit
import AppIntents


@available(iOS 17.0, *)
struct HealthProvider: AppIntentTimelineProvider {
    
    
    func placeholder(in context: Context) -> HealthEntry {
        HealthEntry(date: Date(),  healthType: .placeHolder, value: "0")
    }
    
    func snapshot(for configuration: HealthConfigurationAppIntent, in context: Context) async -> HealthEntry {
      
        HealthEntry(date: Date(),  healthType: .placeHolder, value: "0")
    }
    
    func timeline(for configuration: HealthConfigurationAppIntent, in context: Context) async -> Timeline<HealthEntry> {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        let health = configuration.healthSrc.getHealthType()
        var value: String
        switch health {
        case .steps:
            value = await HealthHelper().fetchStepCount2222()
        case .distance:
            value = await HealthHelper().fetchHeartRate()
        case .waterTrack:
            value = await HealthHelper().fetchWaterConsumption()
        case .sleepTime:
            value = await HealthHelper().fetchSleepDuration()
        case .energyBurn:
            value = await HealthHelper().fetchEnergyBurned()
        case .placeHolder:
            value = ""
        }

        return Timeline(entries: [Entry(date: .now, healthType: health, value: value)], policy: .after(refreshDate))
    }
}

struct HealthEntry: TimelineEntry {
    let date: Date
   
    let healthType: HealthEnum
    let value: String
}
