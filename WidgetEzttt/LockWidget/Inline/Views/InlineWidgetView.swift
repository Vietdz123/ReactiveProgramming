//
//  SquareWidgetView.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import WidgetKit
import SwiftUI


import WidgetKit
import SwiftUI

struct InlineEntry: TimelineEntry {
    
    let date: Date
    let size: CGSize
    let imgSrc: InlineSource
    let title: String

    init(date: Date,  size: CGSize,  imgSrc: InlineSource, title: String) {
        self.date = date
        self.size = size
        self.imgSrc = imgSrc
        self.title = title
    }

}

struct InlineWidgetView : View {
    
    var entry: InlineEntry

    var body: some View {

        LockInlineWidgetView(entry: entry)

    }
}
