//
//  ExtensionProvider.swift
//  WallPaper-CoreData
//
//  Created by MAC on 21/11/2023.
//

import SwiftUI
import WidgetKit
import UIKit


@available(iOSApplicationExtension 17.0, *)
extension HomeProvider {
    
    func getProviderDigitalAndRoutine(viewModel: ImageDataViewModel,
                                      configuration: ConfigurationAppIntent,
                                      size: CGSize,
                                      isDigital: Bool = true,
                                      family: WidgetFamily,
                                      category: CategoryHome?
    ) -> Timeline<SourceImageEntry> {
        
        var images: [UIImage] = []
        switch family {
        case .systemSmall, .systemLarge:
            images = configuration.imageSrc.getImages(family: .square)
            category?.updateNumberSquareImage(number: Double(images.count))
        case .systemMedium:
            images = configuration.imageSrc.getImages(family: .rectangle)
            category?.updateNumberRectImage(number: Double(images.count))
        default:
            images = []
        }
        
        let image = category?.getCurrentImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
        let type = configuration.imageSrc.getFolderType()
        let btnCLModel = configuration.imageSrc.getButtonChecklistModel()
        let routineType = configuration.imageSrc.getRoutineType()
        let digitalType: DigitalFriendType = (configuration.imageSrc.getDigitalType() == .changeBackground) ? .changeBackground : .delayActive(true)
        let delayAnimation = viewModel.category?.delayAnimation ?? 1
        category?.updateNumberCheckedImage(number: Double(btnCLModel.checkImage.count))
        
        var entry = SourceImageEntry(date: .now,
                                    image: image,
                                    size: size,
                                    type: type,
                                    btnChecklistModel: btnCLModel,
                                    imgViewModel: viewModel,
                                    imgSrc: configuration.imageSrc,
                                    routineType: routineType,
                                    digitalType: digitalType)

        if !isDigital  {
            print("DEBUG: siuuu1")
            return Timeline(entries: [entry], policy: .never)
        }
        
        if digitalType == .changeBackground {
            return Timeline(entries: [entry], policy: .never)
        }
        
        if (category?.currentIndexDigitalFriend ?? 0).truncatingRemainder(dividingBy: 2) == 0 {
            return Timeline(entries: [entry], policy: .never)
        } else {
            category?.updateCurrentIndex(isRect: family == .systemMedium)
            let image = category?.getCurrentImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
            entry.digitalType = .delayActive(false)
            let date = Date().addingTimeInterval(delayAnimation)
            let entryDelay = SourceImageEntry(date: date,
                                              image: image,
                                              size: size,
                                              type: type,
                                              btnChecklistModel: btnCLModel,
                                              imgViewModel: viewModel,
                                              imgSrc: configuration.imageSrc,
                                              routineType: routineType,
                                              digitalType: .delayActive(true))
            
            return Timeline(entries: [entry, entryDelay], policy: .never)
        }




        
            

    }
    
    func getProviderSounds(viewModel: ImageDataViewModel,
                           configuration: ConfigurationAppIntent,
                           size: CGSize,
                           family: WidgetFamily,
                           category: CategoryHome?
    ) -> Timeline<SourceImageEntry> {
        
        var entries: [SourceImageEntry] = []
        var image: UIImage = UIImage(named: AssetConstant.imagePlacehodel)!
        
        let soundType = configuration.imageSrc.getSoundType()
        let folderType = configuration.imageSrc.getFolderType()
        
        var images: [UIImage] = []
        switch family {
        case .systemSmall, .systemLarge:
            images = configuration.imageSrc.getImages(family: .square)
            category?.updateNumberSquareImage(number: Double(images.count))
        case .systemMedium:
            images = configuration.imageSrc.getImages(family: .rectangle)
            category?.updateNumberRectImage(number: Double(images.count))
        default:
            images = []
        }
        
        if soundType == .circle {
            category?.updateCurrentIndex(isRect: family == .accessoryRectangular || family == .systemMedium)
            image = category?.getCurrentImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
        } else if soundType == .makeDesicion || folderType == .makeDecision {
            image = category?.getRandomImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
        }
        
        let type = configuration.imageSrc.getFolderType()
        let btnCLModel = configuration.imageSrc.getButtonChecklistModel()
        let routineType = configuration.imageSrc.getRoutineType()
        let delayAnimation = category?.delayAnimation ?? 1
        
        let firstEntry = SourceImageEntry(date: .now,
                                          image: image,
                                          size: size,
                                          type: type,
                                          btnChecklistModel: btnCLModel,
                                          imgViewModel: viewModel,
                                          imgSrc: configuration.imageSrc,
                                          routineType: routineType)
        entries.append(firstEntry)
        
        
        if soundType == .circle && folderType != .makeDecision{
            var count: Double = 1
            
            while category?.isFirstImage == false {
                category?.updateCurrentIndex(isRect: family == .systemMedium)
                count += 1
                
                let entryDate = Date().addingTimeInterval(delayAnimation * count)
                let image = category?.getCurrentImage(images: images) ?? UIImage(named: AssetConstant.imagePlacehodel)!
                let entry = SourceImageEntry(date: entryDate,
                                              image: image,
                                              size: size,
                                              type: type,
                                              btnChecklistModel: btnCLModel,
                                              imgViewModel: viewModel,
                                              imgSrc: configuration.imageSrc,
                                              routineType: routineType)
                
                entries.append(entry)
            }
        }
        
        return Timeline(entries: entries, policy: .never)
    }
    
    func getProviderGif(viewModel: ImageDataViewModel,
                        configuration: ConfigurationAppIntent,
                        size: CGSize,
                        family: WidgetFamily,
                        category: CategoryHome?
    ) -> Timeline<SourceImageEntry> {
        
        var durationAnimation: Double = 240
        if UIDevice.current.userInterfaceIdiom == .pad {
            durationAnimation = 210
        }
        var entries: [SourceImageEntry] = []
        var images: [UIImage] = []
        switch family {
        case .systemSmall, .systemLarge:
            images = configuration.imageSrc.getImages(family: .square)
            category?.updateNumberSquareImage(number: Double(images.count))
        case .systemMedium:
            images = configuration.imageSrc.getImages(family: .rectangle)
            category?.updateNumberRectImage(number: Double(images.count))
        default:
            images = []
        }
        
        
        let type = configuration.imageSrc.getFolderType()
        let btnCLModel = configuration.imageSrc.getButtonChecklistModel()
        let routineType = configuration.imageSrc.getRoutineType()
        
        let delayAnimation = viewModel.category?.delayAnimation ?? 1
        
        let count = Int(durationAnimation / (Double(images.count) * (delayAnimation == 0 ? 1 : delayAnimation))) + 1
        
        
        if type == .placeholder {
            let entry = SourceImageEntry(date: .now,
                                         image: images.first ?? UIImage(named: AssetConstant.imagePlacehodel)!,
                                         size: size,
                                         type: type,
                                         btnChecklistModel: btnCLModel,
                                         imgViewModel: viewModel,
                                         imgSrc: configuration.imageSrc,
                                         routineType: routineType)
            return Timeline(entries: [entry], policy: .never)
        }
        
        let currentDate = Date()
        let numberImage = images.count
        for i in 0 ..< count {
            for (key, image) in images.enumerated() {
                let entryDate = currentDate.addingTimeInterval(Double(key + i * numberImage) * delayAnimation)
                let entry = SourceImageEntry(date: entryDate,
                                             image: image,
                                             size: size,
                                             type: type,
                                             btnChecklistModel: btnCLModel,
                                             imgViewModel: viewModel,
                                             imgSrc: configuration.imageSrc,
                                             routineType: routineType)
                entries.append(entry)
            }
        }

        
        let reloadDate = currentDate.addingTimeInterval(durationAnimation)
        return Timeline(entries: entries, policy: .after(reloadDate))

    }
}
