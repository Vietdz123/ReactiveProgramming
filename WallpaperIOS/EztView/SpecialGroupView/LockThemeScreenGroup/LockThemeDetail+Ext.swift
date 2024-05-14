//
//  LockThemeDetail+Ext.swift
//  WallpaperIOS
//
//  Created by Duc on 11/05/2024.
//

import SwiftUI
import GoogleMobileAds

extension LockThemeDetailView {
    func showSelectWatchRewardAds(completion: @escaping(_ optionSelected: Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let goPreminumAction = UIAlertAction(title: "Go Preminum!", style: .default) {
                UIAlertAction in
            completion(true)
            
        }
        let watchRewardOption = UIAlertAction(title: "Watch Ads", style: .default) {
                UIAlertAction in
            completion(false)
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) {
                UIAlertAction in
            
        }
        alertController.addAction(goPreminumAction)
        alertController.addAction(watchRewardOption)
        alertController.addAction(cancelAction)
        let rootView = UIApplication.shared.windows.first?.rootViewController
        rootView?.present(alertController, animated: true, completion: nil)
    }
    
    @ViewBuilder
    func ControllView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .frame(width: 64, height: 44)
                        .contentShape(Rectangle())
                })
                
                
                Spacer()
                
                
                ZStack{
                    
                    if !store.isPro()  && viewModel.wallpapers[index].private == 1 {
                        Button(action: {
                            showContentPremium.toggle()
                        }, label: {
                            Image("crown")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20, alignment: .center)
                                .frame(width: 60, height: 44)
                        })
                        
                    }
                }
                .frame(width: 60, height: 44)
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
            
            
            Spacer()
            
            ZStack{
                
                VStack(spacing : 0){
                    Spacer()
                    Button(action: {
                        showDownloadView.toggle()
                        
                    }, label: {
                        Image("detail_download")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.main))
                    })
                    
                }
                
            }
            
            
            .padding(.bottom, 24)
            
            ZStack{
                
            }.frame(height: GADAdSizeBanner.size.height)
            
        }.overlay(alignment: .bottom, content: {
            ZStack{
                if store.allowShowBanner(){
                    BannerAdViewInDetail(adStatus: $ctrlViewModel.adStatus)
                }
            }.frame(height: GADAdSizeBanner.size.height)
        })
        .overlay(alignment: .bottom){
            if showDownloadView {
                ZStack(alignment: .bottom){
                    VisualEffectView(effect: UIBlurEffect(style: .dark)).ignoresSafeArea()
                    ThemeDownloadView()
                }
                
                
                
            }
        }
        
    }
    
    
   
    
    
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        
                   
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
        
        
    }
    
    func findObjectByName(list : [LockContent], nameType1 : String, nameType2: String) -> LockContent? {
        print("findObjectByName: \(nameType2)")
        for lockContent in list {
            if lockContent.type == nameType1 || lockContent.type == nameType2 {
                print("findObjectByName: \(nameType2) hasdata")
                print("findObjectByName: \(nameType2) hasdata \(lockContent.data?.images?.count ?? 0)")
                return lockContent
            }
        }
        
        return nil
    }
}


extension CoreDataService {
    
    func downloadGifCoreData(idTheme : Int ,
                             
                             lockModel: LockContent,
                             index: Int,
                             familyLock: FamilyLock,
                             completion: @escaping(() -> Void)) {
        
        let dispathGroup = DispatchGroup()
        var foldername = (index == 1 ? "Left Gif " : "Right Gif") + " #\(idTheme)"
        if familyLock == .rectangle {
            foldername = "Rectangle Gif " + "#\(idTheme)"
        }
        
        let existCate = CoreDataService.shared.getLockCategory(name: foldername)
        if let existCate = existCate, let _ = existCate.items {
            foldername = foldername + " \(Date().formatted(date: .abbreviated, time: .standard))"
        }
        
        let category = CategoryLock(context: context)
        category.groupSizeType = familyLock.name
        category.lockType = LockType.gif.rawValue
        category.name = foldername
        category.creationDate = Date().timeIntervalSinceNow
        category.hasSound = false
        category.delayAnimation = Double(lockModel.data?.delayAnimation  ?? Int(1000.0) ) / 1000.0
        category.familyLockType = familyLock.name
        guard let icons = lockModel.data?.images?.map({ lock in
            return lock.url.full
        }) else { self.saveContext(); completion(); return }
        
        for (index, path) in icons.enumerated()  {
            
            dispathGroup.enter()
            
            let item = ItemHome(context: context)
            item.family = familyLock.name
            item.creationDate = Date().timeIntervalSinceNow + Double(1000 * index)
            item.name = lockModel.data?.images?[index].fileName ?? ""
            
            guard let url = URL(string: path),
                  let file = FileService.relativePath(with: foldername)?.appendingPathComponent("\(item.name ?? "")")
            else {
                context.reset();
                dispathGroup.leave();
                return
            }
            
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
                
                if let _ = error { self.context.reset(); dispathGroup.leave(); return }
                
                guard let urlResponse = urlResponse else  { self.context.reset(); dispathGroup.leave(); return }
                
                FileService.shared.writeToSource(with: foldername, with: urlResponse, to: file)
                
                category.addToItems(item)
                self.saveContext()
                
                dispathGroup.leave()
                
            }.resume()
        }
        
        dispathGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func downloadInlineCoreData(inline: LockContent,
                                completion: @escaping(() -> Void)) {
        
        let familyLock = FamilyLock.inline.name
        var foldername = inline.data?.contentInline ?? ""
        
        let existCate = CoreDataService.shared.getLockCategory(name: foldername)
        if let _ = existCate{
            foldername = foldername + " \(Date().formatted(date: .abbreviated, time: .standard))"
        }
        
        let category = CategoryLock(context: context)
        category.lockType = LockType.inline.rawValue
        category.name = foldername
        category.titleQuote = inline.data?.contentInline ?? ""
        category.creationDate = Date().timeIntervalSinceNow
        category.familyLockType = familyLock
        
        self.saveContext()
        completion()
    }
    
    func downloadIconCoreData(idTheme : Int ,
                              iconModel: LockContent,
                              index: Int,
                              familyLock: FamilyLock,
                              completion: @escaping(() -> Void)) {
        
        var foldername = (index == 1 ? "Left Icon " : "Right Icon ") + "#\(idTheme)"
        if familyLock == .rectangle {
            var foldername = "Icon " + "#\(idTheme)"
        }
        
        let existCate = CoreDataService.shared.getLockCategory(name: foldername)
        if let existCate = existCate, let _ = existCate.items {
            foldername = foldername + " \(Date().formatted(date: .abbreviated, time: .standard))"
        }
        
        let category = CategoryLock(context: context)
        category.lockType = LockType.icon.rawValue
        category.name = foldername
        category.creationDate = Date().timeIntervalSinceNow
        category.hasSound = false
        category.familyLockType = familyLock.name
        
        let item = ItemHome(context: context)
        item.family = familyLock.name
        item.creationDate = Date().timeIntervalSinceNow
        let urlImage = iconModel.data?.images?.first?.url.full ?? ""
        item.name = URL(string: urlImage)?.lastPathComponent ?? ""
        
        guard let url = URL(string: urlImage),
              let file = FileService.relativePath(with: foldername)?.appendingPathComponent("\(item.unwrappedName)")
        else {  context.reset(); completion(); return }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
            
            if let _ = error { self.context.reset(); completion(); return }
            
            guard let urlResponse = urlResponse else  { self.context.reset(); completion(); return  }
            
            FileService.shared.writeToSource(with: foldername, with: urlResponse, to: file)
            
            category.addToItems(item)
            self.saveContext()
            
            completion()
        }.resume()
        
    }
}
