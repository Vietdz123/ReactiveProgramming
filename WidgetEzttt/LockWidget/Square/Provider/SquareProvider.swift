//
//  SquareProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 17.0, *)
struct SquareProvider: AppIntentTimelineProvider {

    
    func placeholder(in context: Context) -> SquareEntry {
        SquareEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: SquareViewModel(), imgSrc: SquareSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }

    
    func snapshot(for configuration: LockSquareConfigurationAppIntent, in context: Context) async -> SquareEntry {
        return SquareEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: SquareViewModel(), imgSrc: SquareSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }
    
    func timeline(for configuration: LockSquareConfigurationAppIntent, in context: Context) async -> Timeline<SquareEntry> {
        
        print("DEBUG: goto timeline ")
         
        let viewModel = SquareViewModel()
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
            let provider = getProvoderIcon(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        case .placeholder:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, category: cate)
            return provider
        }

        
    }
    

}



struct SquareProviderIOS16: IntentTimelineProvider {
    func placeholder(in context: Context) -> SquareEntry {
        print("DEBUG: placeholder")
        return SquareEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: SquareViewModel(), imgSrc: SquareSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
    }
    
    func getSnapshot(for configuration: LockSquareConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (SquareEntry) -> Void) {
        completion(SquareEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: SquareViewModel(), imgSrc: SquareSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent))
    }
    
    func getTimeline(for configuration: LockSquareConfigurationAppIntentIOS16Intent, in context: Context, completion: @escaping (Timeline<SquareEntry>) -> Void) {
        
        let viewModel = SquareViewModel()
        guard let cate = CoreDataService.shared.getLockCategory(name: configuration.name ?? "", family: .square) else {
            let entry: SquareEntry =  SquareEntry(date: .now, image: UIImage(named: AssetConstant.checklistButton)!, size: context.displaySize, type: .placeholder, imgViewModel: SquareViewModel(), imgSrc: SquareSource(id: LockType.placeholder.rawValue, actualName: LockType.placeholder.rawValue), backgroundStyle: .transparent)
       
            completion(Timeline(entries: [entry], policy: .never))
            return
        }
        
        viewModel.loadData(category: cate)
        let type = LockType(rawValue: cate.unwrappedLockType) ?? .placeholder
        let imageSource: SquareSource = .UnwrappedType(id: configuration.name ?? "", actualName: configuration.name ?? "")
        let images = imageSource.getImages()
        cate.updateNumberSquareImage(number: Double(images.count))
        
        switch type {
        case .gif, .placeholder, .icon, .inline:
            var durationAnimation: Double = 60
            if UIDevice.current.userInterfaceIdiom == .pad {
                durationAnimation = 30
            }
            
            var entries: [SquareEntry] = []
            let backgroundStyle = imageSource.getSelectedBackgroundStyle()
            let delayAnimation = viewModel.category?.delayAnimation ?? 1
            
            let count = Int(durationAnimation / (Double(images.count) * (delayAnimation == 0 ? 1 : delayAnimation))) + 1
            print("DEBUG: \(count) count")
            
            if type == .placeholder {
                let entry = SquareEntry(date: .now,
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
                    let entry = SquareEntry(date: entryDate,
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
            
            let entry = SquareEntry(date: .now,
                                       image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                       size: context.displaySize,
                                       type: type,
                                       imgViewModel: viewModel,
                                       imgSrc: imageSource,
                                       backgroundStyle: backgroundStyle,
                                       quotetitle: titleQuote)
            completion(Timeline(entries: [entry], policy: .never))
            
        case .countdown:
            var entries: [SquareEntry] = []
            let backgroundStyle = imageSource.getSelectedBackgroundStyle()
            
            let currentDate = Date()
            for i in 0 ..< 10 {
                let entryDate = currentDate.addingTimeInterval(Double(i) * 30)
                let titleCountdown = getTimeString(timeDestination: cate.timeDestination, today: entryDate, category: cate)
                
                let entry = SquareEntry(date: entryDate,
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
