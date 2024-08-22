//
//  Router.swift
//  WallpaperIOS
//
//  Created by Tiến Việt Trịnh on 22/8/24.
//

import SwiftUI

enum Router: Hashable {
    case gotoEztPosterContactView
    case gotoEztLiveWallpaperView
    case gotoDynamicIslandView
    case gotoShufflePackView
    case gotoLightingEffectView
    case gotoWatchFaceView
    case gotoDepthEffectView
    case gotoLiveWallpaperDetail(currentIndex: Int, wallpapers: [SpLiveWallpaper])
}
