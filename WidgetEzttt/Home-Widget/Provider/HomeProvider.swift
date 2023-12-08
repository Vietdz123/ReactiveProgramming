//
//  Provider.swift
//  WallPaper
//
//  Created by MAC on 23/10/2023.
//

import SwiftUI
import WidgetKit
import UIKit

@available(iOS 17.0, *)
struct HomeProvider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SourceImageEntry {
        print("DEBUG: goto placeholder")
        return SourceImageEntry(date: .now, image: UIImage(named: AssetConstant.imagePlacehodel)!, size: context.displaySize, type: .placeholder, btnChecklistModel: ButtonCheckListModel(), imgViewModel: ImageDataViewModel(), imgSrc: ImageSource(id: "img", actualName: "img"), routineType: .single)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SourceImageEntry {
        print("DEBUG: goto snapshot")
//        WidgetCenter.shared.reloadAllTimelines()
        return SourceImageEntry(date: .now, image: UIImage(named: AssetConstant.imagePlacehodel)!, size: context.displaySize, type: .placeholder, btnChecklistModel: ButtonCheckListModel(), imgViewModel: ImageDataViewModel(), imgSrc: ImageSource(id: "img", actualName: "img"), routineType: .single)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SourceImageEntry> {
        
        print("DEBUG: goto timeline ")
         
        let viewModel = ImageDataViewModel()
        let folderType = configuration.imageSrc.getFolderType()
        let cate = configuration.imageSrc.getCategory()
        viewModel.loadData(category: cate)
        
        print("DEBUG: \(folderType.nameId)")
        switch folderType {
        case .digitalFriend, .routineMonitor, .placeholder:
            let provider = getProviderDigitalAndRoutine(viewModel: viewModel, configuration: configuration, size: context.displaySize, family: context.family, category: cate)
            return provider
            
        case .sound, .makeDecision:
            let provider = getProviderSounds(viewModel: viewModel, configuration: configuration, size: context.displaySize, family: context.family, category: cate)
            return provider
            
        case .gif:
            let provider = getProviderGif(viewModel: viewModel, configuration: configuration, size: context.displaySize, family: context.family, category: cate)
            return provider
        }
        
    }
}
