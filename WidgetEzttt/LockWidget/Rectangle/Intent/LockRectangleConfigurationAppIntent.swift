//
//  LockSquareIntent.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import WidgetKit
import AppIntents


@available(iOSApplicationExtension 17.0, *)
struct LockRectangleConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "LockRectangleConfigurationAppIntent"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Pick a LockWidget")
    var imageSrc: RectSource
}
