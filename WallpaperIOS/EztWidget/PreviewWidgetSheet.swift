//
//  PreviewWidgetSheet.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PreviewWidgetSheet: View {
    
    let widget : EztWidget
    @State var showTuto : Bool = false
    @State var showUpdate : Bool = false
    @State var showSubView : Bool = false
    
    @State var urlPreviewList : [String] = []
    @State var currentIndex : Int = 0
    @State var allowNextImage : Bool = true
    
    @AppStorage("wg_tuto", store: .standard) var showTapJson : Bool = false
    
    @EnvironmentObject var storeVM : MyStore
    
    @State var days : [WeekendDayModel] = [
        WeekendDayModel(day: .sunday),
        WeekendDayModel(day: .monday),
        WeekendDayModel(day: .tuesday),
        WeekendDayModel(day: .wednesday),
        WeekendDayModel(day: .thursday),
        WeekendDayModel(day: .friday),
        WeekendDayModel(day: .saturday)
        
    ]
    
    
    let clickClose : () -> ()
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack(spacing : 0){
                HStack(spacing : 0){
                    Button(action: {
                      
                        shareLinkApp()
                    }, label: {
                        Image("share2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                    
                    if !storeVM.isPro(){
                        Image("crown")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .frame(width: 56, height: 24)
                    }
                    
                  
                    
                    Spacer()
                    
                    
                    Button(action: {
                        clickClose()
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                }.padding(.horizontal, 16)
                    .overlay(
                        Text("Preview".toLocalize())
                            .mfont(17, .bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    )
                
                
                ZStack{
                    
                    if widget.category.id == 2{
                        previewDigitalFriend
                    }else if widget.category.id == 3{
                        previewRountineMonitor()
                    } else if widget.category.id == 6{
                        previewHealth
                    }else if widget.category.id == 4 {
                        previewSounds
                    }else if widget.category.id == 5 {
                        previewGif()
                    }else if widget.category.id == 7 {
                        previewMakeDecision()
                    }else {
                        Text("Please update the app to use this content")
                            .mfont(15, .regular, line: 2)
                            .padding(.horizontal, 24)
                    }
                    
                    
                    
                }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                    .cornerRadius(16)
                    .padding(.vertical, 24)
                    .overlay{
                        if !showTapJson{
                            ZStack{
                                Color.black.opacity(0.2)
                                ResizableLottieView(filename: "preview_wg")
                                    .frame(width: 160, height: 160, alignment: .center)
                                Text("Tap here for preview".toLocalize())
                                    .mfont(13, .regular)
                                    .foregroundColor(.white)
                                    .frame(width: 184, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.8))
                                    )
                                    .offset(x : 44 ,y : 52)
                                
                            }.contentShape(Rectangle())
                                .onTapGesture(perform: {
                                    showTapJson = true
                                })
                        }
                        
                        
                        
                    }
                
                
                
                Button(action: {
                            if #available(iOS 17, *) {
                                            if storeVM.isPro(){
                    if widget.category.id == 6 {
                        HealthHelper().requestHealthKitAuthorization(onGrandted: {
                            // showToastWithContent(image: "checkmark", color: .green, mess: "Permission Grandted!")
                            print("Permission Grandted!")
                            
                        }, onDecline: {
                            print("Permission Decline!")
                            //  showToastWithContent(image: "xmark", color: .red, mess: "Permission Decline!")
                        })
                        var healthE : HealthEnum
                        switch widget.id {
                        case 67 :
                            healthE = .sleepTime
                        case 68 :
                            healthE = .waterTrack
                        case 69 :
                            healthE = .steps
                        case 70 :
                            healthE = .energyBurn
                        case 71 :
                            healthE = .distance
                        default:
                            healthE = .steps
                        }
                        
                        CoreDataService.shared.saveHealthItem(name: healthE.rawValue)
                    }else{
                        
                        WDHomeNetworkManager.shared.downloadFileCoreData(data: widget, completion: {
                            DispatchQueue.main.async{
                                showToastWithContent(image: "checkmark", color: .green, mess: "Download Successful!")
                                let show = UserDefaults.standard.bool(forKey: "wg_show_when_download")
                                
                                ServerHelper.sendDataWidget(widget_id: widget.id)
                                
                                if show == false{
                                    UserDefaults.standard.set(true, forKey: "wg_show_when_download")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                        showTuto.toggle()
                                    })
                                }
                                
                            }
                        })
                    }
                    
                    
                                            }else{
                                                showSubView.toggle()
                                            }
                    
                    
                                        } else {
                                            showUpdate.toggle()
                                        }
                    
                    
                    
                    
                }, label: {
                    Text("Save".toLocalize())
                        .mfont(16, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .frame(width: 240, height: 48)
                        .background(
                            Capsule()
                                .fill(Color.main)
                        )
                })
                .padding(.bottom, 40)
                
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            .background(Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7))
            .cornerRadius(16)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        
        .edgesIgnoringSafeArea(.all)
        .overlay{
            if showUpdate{
                DialogUpdateIOS(show: $showUpdate)
            }
        }
        .overlay{
            if showSubView{
                SpecialSubView( from : "WG" ,onClickClose: {
                    showSubView = false
                })
            }
        }
        .fullScreenCover(isPresented: $showTuto, content: {
            WidgetTutorialView()
        })
        .onAppear(perform: {
            print("HUYYYYY ga non: \(widget.set)")
        })
        
    }
    
    
    
}

#Preview {
    EztWidgetView()
}

//MARK: VIEW
extension PreviewWidgetSheet {
    
    //MARK: - DIGITAL FRIEND
    var previewDigitalFriend : some View{
        ZStack{
            if !urlPreviewList.isEmpty{
                WebImage(url: URL(string: urlPreviewList[currentIndex]))
                    .onSuccess { image, data, cacheType in
                    }
                    .resizable()
                    .placeholder {
                        placeHolderImage()
                        
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .animation(.easeInOut, value: currentIndex)
            }
        }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .clipped()
            .cornerRadius(16)
            .padding(.vertical, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                if currentIndex < urlPreviewList.count - 1{
                    currentIndex += 1
                }else{
                    currentIndex = 0
                }
            }
            .onAppear(perform: {
                if urlPreviewList.isEmpty{
                    urlPreviewList = widget.getRectangleUrlString()
                }
            })
    }
    
    //MARK: - ROUNTINE MONITOR
    @ViewBuilder
    func previewRountineMonitor() -> some View{
        ZStack{
            if ( widget.tags.first?.name  ?? "" ) == "routine_monitor_daily" {
                ZStack(alignment: .bottom){
                    let urlStr = widget.getRectangleUrlString().first ?? ""
                    let btnUnCheckURL = widget.getButtonUnCheckUrlString().first ?? ""
                    let listBtnCheck = widget.getButtonCheckUrlString()
                    
                    
                    WebImage(url: URL(string: urlStr))
                        .onSuccess { image, data, cacheType in
                        }
                        .resizable()
                        .placeholder {
                            placeHolderImage()
                            
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                    
                    HStack(spacing : 0){
                        ForEach(0..<days.count, id : \.self){
                            i in
                            VStack(spacing : 2 ){
                                Button(action: {
                                    days[i].isChecked.toggle()
                                }, label: {
                                    WebImage(url: URL(string: days[i].isChecked ? listBtnCheck[i] : btnUnCheckURL ))
                                        .onSuccess { image, data, cacheType in
                                        }
                                        .resizable()
                                        .scaledToFill()
                                })
                                Text(days[i].day.nameDay)
                                    .mfont(10, .bold)
                                    .foregroundColor(.black)
                                    .fixedSize()
                                
                            }.frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        }
                    }.frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            }else
            {
                ZStack(alignment: .bottom){
                    let urlStr = widget.getRectangleUrlString().first ?? ""
                    let btnUnCheckURL = widget.getButtonUnCheckUrlString().first ?? ""
                    let listBtnCheck = widget.getButtonCheckUrlString()
                    
                    
                    WebImage(url: URL(string: urlStr))
                        .onSuccess { image, data, cacheType in
                        }
                        .resizable()
                        .placeholder {
                            placeHolderImage()
                            
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                        .clipped()
                       
                    HStack(spacing : 0){
                        ForEach(0..<days.count, id : \.self){
                            i in
                            VStack(spacing : 2 ){
                                Button(action: {
                                    if days[i].isChecked {
                                        if days[i].index < listBtnCheck.count - 1 {
                                            days[i].index += 1
                                        }else{
                                            days[i].index = 0
                                            days[i].isChecked.toggle()
                                        }
                                        
                                    }else{
                                        days[i].index = 0
                                        days[i].isChecked.toggle()
                                        
                                    }
                                    
                                }, label: {
                                    WebImage(url: URL(string: days[i].isChecked ? listBtnCheck[ days[i].index ] : btnUnCheckURL ))
                                  //  WebImage(url: URL(string: "" ))
                                        .onSuccess { image, data, cacheType in
                                        }
                                        .resizable()
                                        .scaledToFit()
                                    
                                    
                                    
                                })
                                Text(days[i].day.nameDay)
                                    .mfont(10, .bold)
                                    .foregroundColor(.black)
                                    .fixedSize()
                                
                            }.frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        }
                    }.frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                
                
            }
        }
    }
    
    
    var previewHealth : some View{
        ZStack{
            Image("\(widget.id)")
                .resizable()
                .scaledToFill()
                .clipped()
        }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .cornerRadius(16)
            .padding(.vertical, 24)
            .contentShape(Rectangle())
//            .onTapGesture {
//                HealthHelper().saveSleepDataToHealthKit()
//            }
        
        
    }
    
    var previewSounds : some View{
        ZStack{
            let listImage : [String] = widget.getRectangleUrlString()
            let count = listImage.count
            
            if !listImage.isEmpty{
                
                WebImage(url: URL(string: listImage[currentIndex]))
                    .onSuccess { image, data, cacheType in
                    }
                    .resizable()
                    .placeholder {
                        placeHolderImage()
                        
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                    .clipped()
                    .animation(.easeInOut, value: currentIndex)
                    .onChange(of: currentIndex, perform: { _ in
                        if !allowNextImage {
                            return
                        }
                        
                        if currentIndex < count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                               
                                currentIndex += 1
                            })
                        }else{
                            allowNextImage = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                currentIndex = 0
                            })
                        }
                        
                    })
                    .onTapGesture {
                        
                        if currentIndex != 0 {
                            return
                        }
                        
                        allowNextImage = true
                        if currentIndex < count - 1 {
                                currentIndex += 1
                                if let url = URL(string: widget.sound?.first?.url.full ?? ""){
                                    SoundPlayer.shared.play(url: url)
                                }
                        }
                        

                        
                        
                       
                    }

            }
        }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .cornerRadius(16)
            .padding(.vertical, 24)
            .contentShape(Rectangle())
    }
    
    
    
    
  
    func previewGif() -> some View{
        ZStack{
            let listImage : [String] = widget.getRectangleUrlString()
            let count = listImage.count
            
            if !listImage.isEmpty{
                
                WebImage(url: URL(string: listImage[currentIndex]))
                    .onSuccess { image, data, cacheType in
                    }
                    .resizable()
                    .placeholder {
                        placeHolderImage()
                        
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFill()
                    .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                    .clipped()
                    .animation(.easeInOut, value: currentIndex)
                    .onAppear(perform: {
                        if currentIndex < count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                currentIndex += 1
                            })
                        }
                    })
                    .onChange(of: currentIndex, perform: { _ in
                        if currentIndex < count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                currentIndex += 1
                            })
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                currentIndex = 0
                            })
                        }
                        
                    })
            }
            
        }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .cornerRadius(16)
            .padding(.vertical, 24)
            .contentShape(Rectangle())
    }
    
    
    func previewMakeDecision() -> some View{
        ZStack{
            let listImage : [String] = widget.getRectangleUrlString()
            let count = listImage.count
            
            if !listImage.isEmpty{
              
                    WebImage(url: URL(string: listImage[currentIndex]))
                        .onSuccess { image, data, cacheType in
                        }
                        .resizable()
                        .placeholder {
                            placeHolderImage()
                            
                        }
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
                        .clipped()
                        .animation(.easeInOut, value: currentIndex)
                        .onTapGesture {
                            if let url = URL(string: widget.sound?.first?.url.full ?? ""){
                                SoundPlayer.shared.play(url: url)
                            }
                            
                            currentIndex = Int.random(in: 0...(count - 1 ))
                            
                        }
                
              
                  
            }
            
        }.frame(width: getRect().width - 32, height: ( getRect().width - 32 ) / 2.2 )
            .cornerRadius(16)
            .padding(.vertical, 24)
            .contentShape(Rectangle())
    }
    
    
}
