//
//  DateHelper.swift
//  WallpaperIOS
//
//  Created by Apple on 12/06/2023.
//

import SwiftUI

extension Date {
    func toString(format : String) -> String{
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = format
        return dateFomatter.string(from: self)
    }
}
