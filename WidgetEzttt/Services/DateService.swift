//
//  DateService.swift
//  eWidget
//
//  Created by MAC on 21/12/2023.
//

import Foundation

enum TimeCalendarType: String, CaseIterable {
    case days = "Day"
    case hours = "Hour"
    case minutes = "Minute"
    case seconds = "Second"
}


class DateService {
    
    static let shared = DateService()
    
    func convertSecondsToDaysHoursMinutes(seconds: Double) -> (Double, TimeCalendarType) {
        
        let secondsInt = Int(seconds)
        
        let days = secondsInt / 86400
        let hours = secondsInt % 86400 / 3600
        let minutes = secondsInt % 86400 % 3600 / 60
        let seconds = secondsInt % 86400 % 3600 % 60
        
        if Int(days) > 0 {
            return (Double(days), .days)
        }
        
        if Int(hours) > 0 {
            return (Double(hours), .hours)
        }
        
        if Int(minutes) > 0 {
            return (Double(minutes), .minutes)
        }
        
        if Int(seconds) > 0 {
            return (Double(seconds), .seconds)
        }
        
        return (0, .seconds)
    }
    
    func getTimeString(date: Date = .now) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedTime = dateFormatter.string(from: date)
        
        return formattedTime
    }
    
    func getTimeStringStandBy(date: Date = .now) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let formattedTime = dateFormatter.string(from: date)
        
        return formattedTime
    }
    
}
