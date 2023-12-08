//
//  APIHelper.swift
//  WallpaperIOS
//
//  Created by Duc on 04/12/2023.
//

import Foundation



struct APIHelper {

    static let TOP_WALLPAPER = "api/v1/data?&order_by=daily_rating+desc,updated_at+desc&types[]=private&app=2&screen=exclusive&only_app=1"
    
    static let LIVE_WALLPAPER = "api/v1/videos?"
    
    static let WATCH_FACE = "api/v1/image-specials?&with=special_content+type,id,title&where=special_content_v2_id+5"
    
    static let WIDGET = "https://widget.eztechglobal.com/api/v1/widgets?with=category+id,name-apps+id,name-tags+id,name"
    
}
