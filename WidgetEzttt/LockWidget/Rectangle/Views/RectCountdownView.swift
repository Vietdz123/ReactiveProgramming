//
//  RectCountdownView.swift
//  eWidget
//
//  Created by MAC on 22/12/2023.
//

import Foundation


import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation


struct RectCountdownView: View {
    
    var entry: RectangleEntry
    
    var width: CGFloat {
        return entry.size.width
    }
    
    var height: CGFloat {
        return entry.size.height
    }
    
    var selectedAlignment: AlignmentQuote {
        return entry.imgSrc.getAlignment()
    }
    
    var titleQuote: String {
        return entry.imgSrc.getTitleQuote()
    }
    
    func getFont() -> Font {
        let name = entry.imgSrc.getFontName()
        return .custom(name, fixedSize: 24)
    }
    
    var selectedBackgroundStlye: SelectedBackgroundStyle {
        return entry.backgroundStyle
    }
    
    var isCustomCountdown: Bool {
        return entry.imgSrc.isCustomCoundown()
    }
    
    var body: some View {
        
        if entry.imgSrc.isCustomCoundown() == false {
            ZStack {
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
                    .ignoresSafeArea()
                
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                        .frame(width: entry.size.width * 324 / 480, height: height)
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text("\(dateComponents.0)")
                            .font(getFont())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.leading, 8)
                            .padding(.trailing, 8)
                        
                    
                        Text("\(dateComponents.1)")
                            .font(getFont())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .padding(.horizontal, 4)
                        
                    }
                    .padding(.vertical, 4)
                    .frame(height: height)
                    
                    
                }
            }
            .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
            .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
            .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
            
        } else {
            
            ZStack(alignment: .leading) {
                
                Image(uiImage: entry.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.4, height: height)
                    .padding(.leading, 8)
                    .padding(.vertical, 15)
                    
                
                HStack(alignment: .center, spacing: 8) {
                    Spacer()
                    
                    VStack(alignment: selectedAlignment == .center ? .center : .leading, spacing: 2) {
                        Text("\(titleQuote)")
                            .minimumScaleFactor(0.1)
                        
//                        Text("\(getTimeString())")
//                            .frame(width: width * 0.55, alignment: selectedAlignment == .center ? .center : .leading)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.1)
                        
                    }
                    .padding(.vertical, 4)
                    .multilineTextAlignment(selectedAlignment == .center ? .center : .leading)
                    .padding(.trailing, 4)
                    .frame(width: width * 0.55, height: height)
                    
                }
            }
            .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
            .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
            .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)

        
        }
        
    }
    
//    func getTimeString() -> AttributedString {
//        
//        let today = Date()
//        let toDate = Date(timeIntervalSince1970: entry.imgSrc.getTimeDesitnation())
//        var gapInterval = today.distance(to: toDate)
//        
//        if gapInterval <= 0 {
//            let components = Calendar.current.dateComponents([.day], from: toDate)
//            var count = 0
//            
//            var nextDate: Date?
//            Calendar.current.enumerateDates(
//                startingAfter: toDate,
//                matching: components,
//                matchingPolicy: .nextTime,
//                repeatedTimePolicy: .first,
//                direction: .forward) { (date, strict, stop) in
//                    count += 1
//                    
//                    if count == 12 {
//                        nextDate = date
//                        stop = true
//                    }
//                }
//            
//            gapInterval = today.distance(to: nextDate ?? .distantFuture)
//        }
//        
//        let dayData = DateService.shared.convertSecondsToDaysHoursMinutes(seconds: gapInterval)
//        let timeValue = Int(dayData.0)
//        let isPrunal = (timeValue > 1) ? "s" : ""
//        
//        var attributed = AttributedString("\(timeValue) ")
//        attributed.font = .fontSVNAVoBold(17)
//        attributed.foregroundColor = .white
//        
//        var secondAttributed = AttributedString("\(dayData.1.rawValue)\(isPrunal)")
//        secondAttributed.font = .fontSVNAVoRegular(15)
//        secondAttributed.foregroundColor = .white
//        
//        attributed.append(secondAttributed)
//        return attributed
//    }
    
    var dateComponents: (String, String) {
        
        if entry.countdownDay == nil {
            return ("", "")
        }
        let inputString = entry.countdownDay ?? ""
        
        // Initialize a scanner with the input string
        let scanner = Scanner(string: inputString)
        
        // Extract an integer (if present)
        var extractedNumber: Int = 0
        scanner.scanInt(&extractedNumber)
        
        // Skip the newline character
        scanner.scanString("\n")
        
        // Extract the remaining text
        var extractedText: NSString?
        scanner.scanUpToCharacters(from: .newlines, into: &extractedText)
        
        // Convert the extractedText to a Swift String
        let text = extractedText as String?
        
        // Print the results
        return (String(extractedNumber), text ?? "")
    }
}



