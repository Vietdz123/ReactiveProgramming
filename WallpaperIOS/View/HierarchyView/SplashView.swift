//
//  SplashView.swift
//  WallpaperIOS
//
//  Created by Mac on 11/09/2023.
//

import SwiftUI
import NavigationTransitions

import AppTrackingTransparency

struct SplashView: View {
    
    
    @StateObject var appVM : AppViewModel = .init()
    @StateObject var myStore : MyStore = .init()
    @StateObject var rewardAd : RewardAd = .init()
    @StateObject var interAd : InterstitialAdLoader = .init()
    @StateObject var homeVM : HomeViewModel = .init()
    @State private var splash_process = 0.0
    
    
    let openAd : OpenAd = OpenAd()
    @Environment(\.scenePhase)  var scenePhase
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
//               
//                    NavigationLink(destination:
//                        OnboardingSubView()
//                        .navigationBarTitle("", displayMode: .inline)
//                        .navigationBarHidden(true)
//                        .environmentObject(homeVM)
//                        .environmentObject(myStore)
//                        .environmentObject(interAd)
//                        .environmentObject(rewardAd)
//                                   , isActive: $appVM.navigateToOnboarding, label: {
//                        EmptyView()
//                    })
//                    
                    NavigationLink(destination:
                        OnboardingVerTwoSubView()
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                        .environmentObject(homeVM)
                        .environmentObject(myStore)
                        .environmentObject(interAd)
                        .environmentObject(rewardAd)
                                   , isActive: $appVM.navigateToOnboarding2, label: {
                        EmptyView()
                    })
               
                
                
                
                
                NavigationLink(destination:
                                EztMainView()
                    .environmentObject(myStore)
                    .environmentObject(interAd)
                    .environmentObject(rewardAd)
                               , isActive: $appVM.navigateToHome, label: {
                    EmptyView()
                })
                
                
                SplashScreenView()
            }
            
            
        }.navigationViewStyle(.stack)
            .navigationTransition(.fade(.out))
            .onViewDidLoad {
                openAd.requestAppOpenAd()
                Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { timer in
                    
                                    if splash_process < 100 {
                                        splash_process += 1
                                    }else{
                                        timer.invalidate()
                                    }
                })
            }

            .onChange(of: splash_process, perform: {
                newValue in
                if splash_process == 100 {
                //    appVM.navigateToHome.toggle()
                   appVM.navigateToOnboarding2.toggle()
//                    if  UserDefaults.standard.bool(forKey: "firstTimeLauncher") == false {
//                        
//                        
//                        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                            if status == .authorized{
//                                Firebase_log("tracking_authorized")
//                            }
//                            
//                          })
//                        
//                        
//                   if myStore.isVer1(){
//                       appVM.navigateToOnboarding.toggle()
//                    }else{
//                        appVM.navigateToOnboarding2.toggle()
//                    }
//                        
//
//                    }else{
//                        
//                        if myStore.isPro(){
//                            appVM.navigateToHome.toggle()
//                        }else{
//                            openAd.tryToPresentAd(onCommit: {
//                                _ in
//                                appVM.navigateToHome.toggle()
//                            })
//                        }
//                        
//                        
//                    }
                    
                }
            })
            .onChange(of: scenePhase, perform: {
                newPhase in
                if newPhase == .active {
                    
                    if UserDefaults.standard.bool(forKey: "firstTimeLauncher") == false{
                        return
                    }
                    
                    if myStore.isPro(){
                        return
                    }
                    
                    if splash_process < 100 {
                        return
                    }
                    
                    if !appVM.appGoBackground {
                        return
                    }
                    
                    openAd.tryToPresentAd(onCommit: {
                        _ in
                        appVM.appGoBackground = false
                    })
                    
                    
                    
                }else if newPhase == .inactive{
                    
                }else {
                    UserDefaults.standard.set(true, forKey: "user_exit_app")
                    appVM.appGoBackground = true
                }
            })
        
    }
    
    

    
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

class AppViewModel: ObservableObject {
    
    @Published var appGoBackground : Bool = false
    
    @Published var navigateToOnboarding : Bool = false
    @Published var navigateToOnboarding2 : Bool = false
    @Published var navigateToHome : Bool = false
    
    @Published var hasLoadOpenAds : Bool = false
    @Published var showOpenAds : Bool = UserDefaults.standard.bool(forKey: "not_first_time_enter_app")
    @Published var adStatus : AdStatus = .loading
    @Published var notFirstTime : Bool
    
    
    @Published var openApp : Bool = true
    
    init() {
        self.notFirstTime = UserDefaults.standard.bool(forKey: "not_first_time_enter_app")
        
        addDefault()
        
    }
    
    func addDefault(){
        let launchedBefore = UserDefaults.standard.bool(forKey: "alreadylaunched")
        if launchedBefore {
            
        } else {
            UserDefaults.standard.set(4, forKey: "current_coin")
            UserDefaults.standard.set(Date().toString(format: "dd/MM/yyyy"), forKey: "date_install")
            getCountryName()
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let dataPath1 = documentsURL.appendingPathComponent("ImageDownloaded")
            if !fileManager.fileExists(atPath: dataPath1.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath1.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                }
            }
            let dataPath2 = documentsURL.appendingPathComponent("VideoDownloaded")
            if !fileManager.fileExists(atPath: dataPath2.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath2.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    
                }
            }
            let dataPath3 = documentsURL.appendingPathComponent("VideoPreviewDownloaded")
            if !fileManager.fileExists(atPath: dataPath3.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath3.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    
                }
            }
            UserDefaults.standard.set(true, forKey: "alreadylaunched")
        }
    }
    
    func getCountryName(){
        guard let url  = URL(string: "http://www.geoplugin.net/json.gp") else {
            return
        }
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            
            
            if err != nil {
                print(err!.localizedDescription)
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        if let countryName = json["geoplugin_countryName"] as? String {
                            UserDefaults.standard.set(countryName, forKey: "user_country")
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
}
