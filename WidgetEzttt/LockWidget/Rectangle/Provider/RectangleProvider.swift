//
//  LockRectProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//


import WidgetKit
import SwiftUI

@available(iOSApplicationExtension 17.0, *)
struct RectangleProvider: AppIntentTimelineProvider {

    
    func placeholder(in context: Context) -> RectangleEntry {
        RectangleEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: RectangleViewModel(), imgSrc: RectSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }

    
    func snapshot(for configuration: LockRectangleConfigurationAppIntent, in context: Context) async -> RectangleEntry {
        return RectangleEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: RectangleViewModel(), imgSrc: RectSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }
    
    func timeline(for configuration: LockRectangleConfigurationAppIntent, in context: Context) async -> Timeline<RectangleEntry> {
         
        let viewModel = RectangleViewModel()
        let cate = configuration.imageSrc.getCategory()
        viewModel.loadData(category: cate)

        let type = configuration.imageSrc.getLockType()
        switch type {
        case .gif:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .quotes:
            let provider = getProvoderQuote(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .inline:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .countdown:
            let provider = getProviderCountdown(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .icon:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .placeholder:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        }
    }
}



struct RectangleLockProviderIOS16: IntentTimelineProvider {
    func placeholder(in context: Context) -> RectangleEntry {
        print("DEBUG: placeholder")
        return RectangleEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: RectangleViewModel(), imgSrc: RectSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }
    
    func getSnapshot(for configuration: LockRectangleConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (RectangleEntry) -> Void) {
        completion(RectangleEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: RectangleViewModel(), imgSrc: RectSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent))
    }
    
    func getTimeline(for configuration: LockRectangleConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (Timeline<RectangleEntry>) -> Void) {
        
        let viewModel = RectangleViewModel()
        guard let cate = CoreDataService.shared.getLockCategory(name: configuration.name ?? "", family: .rectangle) else {
            let entry: RectangleEntry =  RectangleEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: RectangleViewModel(), imgSrc: RectSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
       
            completion(Timeline(entries: [entry], policy: .never))
            return
        }
        
        viewModel.loadData(category: cate)
        let type = LockType(rawValue: cate.unwrappedLockType) ?? .placeholder
        let imageSource: RectSource = .UnwrappedType(id: configuration.name ?? "", actualName: configuration.name ?? "")
        let images = imageSource.getImages()
        cate.updateNumberRectImage(number: Double(images.count))
        
        switch type {
        case .icon:
            let entry = RectangleEntry(date: .now,
                                       image: images[0],
                                       size: context.displaySize,
                                       type: .icon,
                                       imgViewModel: viewModel,
                                       imgSrc: imageSource,
                                       backgroundStyle: .transparent)
            completion(Timeline(entries: [entry], policy: .never))
            
        case .gif, .placeholder, .inline:
            var durationAnimation: Double = 60
            if UIDevice.current.userInterfaceIdiom == .pad {
                durationAnimation = 30
            }
            
            var entries: [RectangleEntry] = []
            let backgroundStyle = imageSource.getSelectedBackgroundStyle()
            let delayAnimation = viewModel.category?.delayAnimation ?? 1
            
            let count = Int(durationAnimation / (Double(images.count) * (delayAnimation == 0 ? 1 : delayAnimation))) + 1
            print("DEBUG: \(count) count")
            
            if type == .placeholder {
                let entry = RectangleEntry(date: .now,
                                           image: UIImage(named: AssetConstant.imagePlacehodel)!,
                                           size: context.displaySize,
                                           type: type,
                                           imgViewModel: viewModel,
                                           imgSrc: imageSource,
                                           backgroundStyle: backgroundStyle)
                completion(Timeline(entries: [entry], policy: .never))
            }
            
            let currentDate = Date()
            let numberImage = images.count
            for i in 0 ..< count {
                for (key, image) in images.enumerated() {
                    let entryDate = currentDate.addingTimeInterval(Double(key + i * numberImage) * delayAnimation)
                    let entry = RectangleEntry(date: entryDate,
                                               image: image,
                                               size: context.displaySize,
                                               type: type,
                                               imgViewModel: viewModel,
                                               imgSrc: imageSource,
                                               backgroundStyle: backgroundStyle)
                    entries.append(entry)
                }
            }

            
            let reloadDate = currentDate.addingTimeInterval(300)
            completion(Timeline(entries: entries, policy: .after(reloadDate)))
            
        case .quotes:
            let backgroundStyle = imageSource.getSelectedBackgroundStyle()
            let titleQuote = cate.titleQuote ?? ""
            
            let entry = RectangleEntry(date: .now,
                                       image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                       size: context.displaySize,
                                       type: type,
                                       imgViewModel: viewModel,
                                       imgSrc: imageSource,
                                       backgroundStyle: backgroundStyle,
                                       quotetitle: titleQuote)
            completion(Timeline(entries: [entry], policy: .never))
            
        case .countdown:
            var entries: [RectangleEntry] = []
            let backgroundStyle = imageSource.getSelectedBackgroundStyle()
            
            let currentDate = Date()
            for i in 0 ..< 10 {
                let entryDate = currentDate.addingTimeInterval(Double(i) * 30)
                let titleCountdown = getTimeString(timeDestination: cate.timeDestination, today: entryDate, category: cate)
                
                let entry = RectangleEntry(date: entryDate,
                                           image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                           size: context.displaySize,
                                           type: type,
                                           imgViewModel: viewModel,
                                           imgSrc: imageSource,
                                           backgroundStyle: backgroundStyle,
                                           countdownDay: titleCountdown)
                entries.append(entry)
                
            }

            
            let reloadDate = currentDate.addingTimeInterval(300)
            completion(Timeline(entries: entries, policy: .after(reloadDate)))
            
        }
    }
}
