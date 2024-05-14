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

import SwiftUI



struct SquareEntry: TimelineEntry {
    let date: Date
    let image: UIImage
    let size: CGSize
    let type: LockType
    let imgViewModel: SquareViewModel
    let imgSrc: SquareSource
    let backgroundStyle: SelectedBackgroundStyle
    var countdownDay: String?
    var quotetitle: String?
}

enum SelectedBackgroundStyle: Int, CaseIterable {
    case defaultBackground
    case border
    case transparent
}

extension View {
    func cornerRadiusWithBorder(radius: CGFloat, borderLineWidth: CGFloat = 1, borderColor: Color = .gray, antialiased: Bool = true) -> some View {
        modifier(ModifierCornerRadiusWithBorder(radius: radius, borderLineWidth: borderLineWidth, borderColor: borderColor, antialiased: antialiased))
    }
}

fileprivate struct ModifierCornerRadiusWithBorder: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(self.radius, antialiased: self.antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: self.radius)
//                    .inset(by: self.borderLineWidth)
                    .strokeBorder(self.borderColor, lineWidth: self.borderLineWidth, antialiased: self.antialiased)
            )
    }
}

struct SquareWidgetView : View {
    
    var entry: SquareEntry

    var body: some View {

        switch entry.type {
        case .gif:
            SquareBackgroundView(entry: entry)
        case .quotes:
            SquareQuoteView(entry: entry)
        case .countdown:
            SquareCountdownView(entry: entry)
        case .placeholder:
            LockPlaceHolderView(size: entry.size)
        case .icon:
            SquareIconView(entry: entry)
        default:
            EmptyView()
        }

    }
}
