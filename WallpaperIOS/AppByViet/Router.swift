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
    case gotoNewestLightingEffect
    case gotoNewestAnSpecialWatchFaceView
    case gotoDepthEffectView
    case gotoLiveWallpaperDetail(currentIndex: Int, wallpapers: [SpLiveWallpaper])
    case gotoNewestWatchFaceView
    case gotoShufflePackeList
    case gotoShuffleDetailView(wallpaper: SpWallpaper)
    case gotoSpecialWalliveDetailView(currentIndex: Int, wallpapers: [SpWallpaper])
    case gotoSpeicalPageView(title: String, type: Int, tadId: Int)
    case gotoSpecialOnePageDetailView(wallpapers: [SpWallpaper], index: Int)
    case gotoNewestAndPopularDynamic
    case gotoNewestDynamicView(wallpapers: [SpWallpaper])
    case gotoListDepthEffectView(wallpapers: [SpWallpaper])
    case gotoLockThemeListView(wallpapers: [LockScreenObj])
    case gotoLockThemeDetailView(wallpapers: [LockScreenObj], currentIndex: Int)
}
