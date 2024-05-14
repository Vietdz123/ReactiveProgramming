//
//  ExtensionProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 17.0, *)
extension SquareProvider {
    
    
    func getProviderDigitalAndRoutine(viewModel: SquareViewModel,
                                      configuration: LockSquareConfigurationAppIntent,
                                      size: CGSize,
                                      isDigital: Bool = true,
                                      category: CategoryLock?
    ) -> Timeline<SquareEntry> {
        
        let images = configuration.imageSrc.getImages()
        category?.updateNumberRectImage(number: Double(images.count))

        
        let image = category?.getCurrentImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
        let type = configuration.imageSrc.getLockType()
        let backgroundStyle = configuration.imageSrc.getSelectedBackgroundStyle()
        
        let entry = SquareEntry(date: .now,
                                image: image,
                                size: size,
                                type: type,
                                imgViewModel: viewModel,
                                imgSrc: configuration.imageSrc, 
                                backgroundStyle: backgroundStyle)
        
        if isDigital {
            return Timeline(entries: [entry], policy: .never)
        } else {
            return Timeline(entries: [entry], policy: .never)
        }
    }
    
    
    func getProviderGif(viewModel: SquareViewModel,
                        configuration: LockSquareConfigurationAppIntent,
                        size: CGSize,
                        category: CategoryLock?
    ) -> Timeline<SquareEntry> {
        
        var durationAnimation: Double = 60
        if UIDevice.current.userInterfaceIdiom == .pad {
            durationAnimation = 30
        }
        var entries: [SquareEntry] = []
        let images = configuration.imageSrc.getImages()
        category?.updateNumberRectImage(number: Double(images.count))
        
        
        let type = configuration.imageSrc.getLockType()
        let delayAnimation = viewModel.category?.delayAnimation ?? 1
        
        let count = Int(durationAnimation / (Double(images.count) * (delayAnimation == 0 ? 1 : delayAnimation))) + 1
        let backgroundStyle = configuration.imageSrc.getSelectedBackgroundStyle()
        
        if type == .placeholder {
            let entry = SquareEntry(date: .now,
                                    image: UIImage(named: AssetConstant.imagePlacehodel)!,
                                    size: size,
                                    type: type,
                                    imgViewModel: viewModel,
                                    imgSrc: configuration.imageSrc,
                                    backgroundStyle: backgroundStyle)
            return Timeline(entries: [entry], policy: .never)
        }
        
        let currentDate = Date()
        let numberImage = images.count
        for i in 0 ..< count {
            for (key, image) in images.enumerated() {
                let entryDate = currentDate.addingTimeInterval(Double(key + i * numberImage) * delayAnimation)
                let entry = SquareEntry(date: entryDate,
                                           image: image,
                                           size: size,
                                           type: type,
                                           imgViewModel: viewModel,
                                           imgSrc: configuration.imageSrc,
                                        backgroundStyle: backgroundStyle)
                entries.append(entry)
            }
        }

        
        let reloadDate = currentDate.addingTimeInterval(300)
        return Timeline(entries: entries, policy: .after(reloadDate))

    }
    
    func getProviderCountdown(viewModel: SquareViewModel,
                              configuration: LockSquareConfigurationAppIntent,
                              size: CGSize,
                              category: CategoryLock?
    ) -> Timeline<SquareEntry> {

        var entries: [SquareEntry] = []
        let images = configuration.imageSrc.getImages()
        
        let timeDestination = category?.timeDestination ?? Date().timeIntervalSince1970
        category?.updateNumberRectImage(number: Double(images.count))
        
        let type = configuration.imageSrc.getLockType()
        let backgroundStyle = configuration.imageSrc.getSelectedBackgroundStyle()
        
        let currentDate = Date()
        for i in 0 ..< 10 {
            let entryDate = currentDate.addingTimeInterval(Double(i) * 30)
            let titleCountdown = getTimeString(timeDestination: timeDestination, today: entryDate, category: category)
            let entry = SquareEntry(date: entryDate,
                                       image: images[0],
                                       size: size,
                                       type: type,
                                       imgViewModel: viewModel,
                                       imgSrc: configuration.imageSrc,
                                       backgroundStyle: backgroundStyle,
                                       countdownDay: titleCountdown)
            entries.append(entry)
            
        }

        
        let reloadDate = currentDate.addingTimeInterval(30)
        return Timeline(entries: entries, policy: .after(reloadDate))

    }
    
    func getProvoderQuote(viewModel: SquareViewModel,
                          configuration: LockSquareConfigurationAppIntent,
                          size: CGSize,
                          category: CategoryLock?
    ) -> Timeline<SquareEntry> {
        
        let images = configuration.imageSrc.getImages()
        category?.updateNumberRectImage(number: Double(images.count))
            
        let type = configuration.imageSrc.getLockType()
        let backgroundStyle = configuration.imageSrc.getSelectedBackgroundStyle()
        let titleQuote = category?.titleQuote ?? ""
        
        let entry = SquareEntry(date: .now,
                                image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                size: size,
                                type: type,
                                imgViewModel: viewModel,
                                imgSrc: configuration.imageSrc,
                                backgroundStyle: backgroundStyle,
                                quotetitle: titleQuote)
        

        return Timeline(entries: [entry], policy: .never)
    }
    
    func getProvoderIcon(viewModel: SquareViewModel,
                         configuration: LockSquareConfigurationAppIntent,
                         size: CGSize,
                         category: CategoryLock?
    ) -> Timeline<SquareEntry> {
        
        let images = configuration.imageSrc.getImages()
        category?.updateNumberRectImage(number: Double(images.count))
            
        let type = configuration.imageSrc.getLockType()
        let backgroundStyle = configuration.imageSrc.getSelectedBackgroundStyle()
        let titleQuote = category?.titleQuote ?? ""
        
        let entry = SquareEntry(date: .now,
                                image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                size: size,
                                type: type,
                                imgViewModel: viewModel,
                                imgSrc: configuration.imageSrc,
                                backgroundStyle: backgroundStyle,
                                quotetitle: titleQuote)
        

        return Timeline(entries: [entry], policy: .never)
    }
}


@available(iOSApplicationExtension 17.0, *)
extension SquareProvider {
    
    func getTimeString(timeDestination: Double, today: Date, category: CategoryLock?) -> String {
        
        guard let category = category else { return "" }
        
        let toDate = Date(timeIntervalSince1970: timeDestination)
        var gapInterval = today.distance(to: toDate)
        
        if gapInterval <= 0 {
            let components = Calendar.current.dateComponents([.day], from: toDate)
            var count = 0

            var nextDate: Date?
            Calendar.current.enumerateDates(
                startingAfter: toDate,
                matching: components,
                matchingPolicy: .nextTime,
                repeatedTimePolicy: .first,
                direction: .forward) { (date, strict, stop) in
                count += 1
         
                if count == 12 {
                    nextDate = date
                    stop = true
                }
            }

            category.timeDestination = nextDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            CoreDataService.shared.saveContext()
            gapInterval = today.distance(to: nextDate ?? .distantFuture) 
        }
        
        let dayData = DateService.shared.convertSecondsToDaysHoursMinutes(seconds: gapInterval)
        let timeValue = Int(dayData.0)
        let isPrunal = (timeValue > 1) ? "s" : ""
        let title = "\(timeValue)\n\(dayData.1.rawValue)\(isPrunal)"
        
        return title
    }
    
}


extension SquareProviderIOS16 {
    
    func getTimeString(timeDestination: Double, today: Date, category: CategoryLock?) -> String {
        
        guard let category = category else { return "" }
        
        let toDate = Date(timeIntervalSince1970: timeDestination)
        var gapInterval = today.distance(to: toDate)
        
        if gapInterval <= 0 {
            let components = Calendar.current.dateComponents([.day], from: toDate)
            var count = 0

            var nextDate: Date?
            Calendar.current.enumerateDates(
                startingAfter: toDate,
                matching: components,
                matchingPolicy: .nextTime,
                repeatedTimePolicy: .first,
                direction: .forward) { (date, strict, stop) in
                count += 1
         
                if count == 12 {
                    nextDate = date
                    stop = true
                }
            }

            category.timeDestination = nextDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            CoreDataService.shared.saveContext()
            gapInterval = today.distance(to: nextDate ?? .distantFuture)
        }
        
        let dayData = DateService.shared.convertSecondsToDaysHoursMinutes(seconds: gapInterval)
        let timeValue = Int(dayData.0)
        let isPrunal = (timeValue > 1) ? "s" : ""
        let title = "\(timeValue)\n\(dayData.1.rawValue)\(isPrunal)"
        
        return title
    }
    
}
