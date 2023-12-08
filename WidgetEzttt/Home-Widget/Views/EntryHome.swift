//
//  EntryHome.swift
//  WidgetEztttExtension
//
//  Created by Duc on 30/11/2023.
//

import SwiftUI


import WidgetKit
import SwiftUI
                
struct SourceImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage
    let size: CGSize
    let type: WDHomeFolderType
    let btnChecklistModel: ButtonCheckListModel
    let imgViewModel: ImageDataViewModel
    let imgSrc: ImageSource
    let routineType: RoutinMonitorType
    var digitalType: DigitalFriendType
    
    init(date: Date,
         image: UIImage,
         size: CGSize,
         type: WDHomeFolderType,
         btnChecklistModel: ButtonCheckListModel,
         imgViewModel: ImageDataViewModel,
         imgSrc: ImageSource,
         routineType: RoutinMonitorType)
    {
        self.date = date
        self.image = image
        self.size = size
        self.type = type
        self.btnChecklistModel = btnChecklistModel
        self.imgViewModel = imgViewModel
        self.imgSrc = imgSrc
        self.routineType = routineType
        self.digitalType = .changeBackground
    }
    
    init(date: Date,
         image: UIImage,
         size: CGSize,
         type: WDHomeFolderType,
         btnChecklistModel: ButtonCheckListModel,
         imgViewModel: ImageDataViewModel,
         imgSrc: ImageSource,
         routineType: RoutinMonitorType,
         digitalType: DigitalFriendType)
    {
        self.date = date
        self.image = image
        self.size = size
        self.type = type
        self.btnChecklistModel = btnChecklistModel
        self.imgViewModel = imgViewModel
        self.imgSrc = imgSrc
        self.routineType = routineType
        self.digitalType = digitalType
    }
}

@available(iOS 17.0, *)
struct WallpaperWidgetEntryView : View {
    
    var entry: SourceImageEntry

    var body: some View {

        switch entry.type {
        case .digitalFriend, .sound, .gif, .makeDecision:
            BackgroudView(entry: entry)
        case .routineMonitor:
            CheckListView(entry: entry)
        case .placeholder:
            PlaceholderView(size: entry.size)
        }

    }
}
