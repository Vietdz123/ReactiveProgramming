//
//  APIHelper.swift
//  WallpaperIOS
//
//  Created by Duc on 04/12/2023.
//

import Foundation



struct APIHelper {

    
    //MARK: tat ca content lay tu Hoa`
    static let TOP_WALLPAPER = "api/v1/data?&order_by=daily_rating+desc,updated_at+desc&app=2&screen=exclusive&only_app=1" // &types[]=private
    
    static let LIVE_WALLPAPER = "api/v1/videos?"
    
    static let WATCH_FACE = "api/v1/image-specials?&with=special_content+type,id,title&where=special_content_v2_id+5"
    //https://dev-widget.eztechglobal.com/
    static let WIDGET = "https://widget.eztechglobal.com/api/v1/widgets?with=category+id,name-apps+id,name-tags+id,name"
  //  static let WIDGET = "https://dev-widget.eztechglobal.com/api/v1/widgets?with=category+id,name-apps+id,name-tags+id,name"
    
}
