//
//  SquareCountdownView.swift
//  eWidget
//
//  Created by MAC on 22/12/2023.
//

import SwiftUI
import WidgetKit
import AppIntents
import AVFoundation

enum AlignmentQuote: String {
    case center = "center"
    case left = "left"
}

struct SquareCountdownView: View {

    var entry: SquareEntry
    
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
        return .custom(name, fixedSize: 11)
    }
    
    var selectedBackgroundStlye: SelectedBackgroundStyle {
        return entry.backgroundStyle
    }
    
    var squareFamily: FamilyTypeGifResonpse {
        return entry.imgSrc.getFamilySizeType()
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
                
                if squareFamily == .squareText {
                    Text("\(entry.countdownDay ?? "")")
                        .font(getFont())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, entry.size.height / 2)
                        .minimumScaleFactor(0.7)
                }
                
            }
            .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
            .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
        } else {
        
            VStack(alignment: .center, spacing: 2) {

                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height / 2 - 8)

                VStack(alignment: selectedAlignment == .center ? .center : .leading, spacing: 0) {
                    Text("\(titleQuote)")
                        .minimumScaleFactor(0.1)
                    
//                    Text("\(getTimeString)")
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.1)
//                        .frame(maxWidth: .infinity)

                }
                .multilineTextAlignment(selectedAlignment == .center ? .center : .leading)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                
                            
            }
            .frame(width: width, height: height)
            .background(selectedBackgroundStlye == .defaultBackground ? Color.white.opacity(0.25) : .clear)
            .cornerRadius(12)
            .cornerRadiusWithBorder(radius: 12, borderLineWidth: 1, borderColor: selectedBackgroundStlye == .border ? .white : .clear)
        }
    }
    
//    var getTimeString: AttributedString {
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
//                count += 1
//         
//                if count == 12 {
//                    nextDate = date
//                    stop = true
//                }
//            }
//
//            gapInterval = today.distance(to: nextDate ?? .distantFuture)
//        }
//        
//        let dayData = DateService.shared.convertSecondsToDaysHoursMinutes(seconds: gapInterval)
//        let timeValue = Int(dayData.0)
//        let isPrunal = (timeValue > 1) ? "s" : ""
//        var attributed = AttributedString("\(timeValue) ")
//        attributed.font = .fontSVNAVoBold(15)
//        attributed.foregroundColor = .white
//        
//        var secondAttributed = AttributedString("\(dayData.1.rawValue)\(isPrunal)")
//        secondAttributed.font = .fontSVNAVoRegular(13)
//        secondAttributed.foregroundColor = .white
//        
//        attributed.append(secondAttributed)
//        return attributed
//    }
}



