//
//  MView.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//


import SwiftUI
import WidgetKit
import AppIntents

@available(iOS 17.0, *)
struct PlaceholderView: View {
    @Environment(\.widgetFamily) var family
    var size: CGSize
    
    var body: some View {
        ZStack {
            if family == .systemMedium{
                Image("bg99")
                    .resizable()
                
            }else{
                Image("bg98")
                    .resizable()
            }
        }
    }
}


struct BackgroudView: View {
    
    var entry: SourceImageEntry
    @Environment(\.widgetFamily) var family
    
    var is_rect: Bool {
        if family == .accessoryRectangular || family == .systemMedium {
            return true
        } else {
            return false
        }
    }
    
    var digitalType: DigitalFriendType {
        return entry.digitalType
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
                .ignoresSafeArea()
                

        }
    }
}


@available(iOS 17.0, *)
struct CheckListView: View {
    
    var entry: SourceImageEntry
    @Environment(\.widgetFamily) var family
    var body: some View {
        ZStack {
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .frame(maxWidth: entry.size.width, maxHeight: entry.size.height)
                .ignoresSafeArea()
            
            switch family {
                   case .systemSmall:
                
                GeometryReader{
                    proxy in
                    VStack(spacing: 0,content: {
                        
                        Spacer()
                        HStack(spacing: 0,content: {
                            DayView(model: WeekendDayModel(day: .sunday), entry: entry)
                            DayView(model: WeekendDayModel(day: .monday), entry: entry)
                            DayView(model: WeekendDayModel(day: .tuesday), entry: entry)
                            DayView(model: WeekendDayModel(day: .wednesday), entry: entry)
                           
                           
                        }).padding(.horizontal, 12)
                        HStack(spacing: 0,content: {
                           
                            DayView(model: WeekendDayModel(day: .thursday), entry: entry)
                            DayView(model: WeekendDayModel(day: .friday), entry: entry)
                            DayView(model: WeekendDayModel(day: .saturday), entry: entry)
                          
                           
                        }).frame(width: ( proxy.size.width - 24 ) * 3 / 4 )
                            .padding(.bottom, 8)
                            .padding(.top, 2)
                        
                       
                    })
                }
              
                   case .systemMedium:
                VStack(spacing: 0,content: {
                    
                    Spacer()
                    
                    HStack(spacing: 0, content: {
                  
                        DayView(model: WeekendDayModel(day: .sunday), entry: entry)
                        DayView(model: WeekendDayModel(day: .monday), entry: entry)
                        DayView(model: WeekendDayModel(day: .tuesday), entry: entry)
                        DayView(model: WeekendDayModel(day: .wednesday), entry: entry)
                        DayView(model: WeekendDayModel(day: .thursday), entry: entry)
                        DayView(model: WeekendDayModel(day: .friday), entry: entry)
                        DayView(model: WeekendDayModel(day: .saturday), entry: entry)
                       
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                   
                })
                   case .systemLarge:
                GeometryReader{
                    proxy in
                    VStack(spacing: 0,content: {
                        
                        Spacer()
                        HStack(spacing: 0,content: {
                            DayView(model: WeekendDayModel(day: .sunday), entry: entry)
                            DayView(model: WeekendDayModel(day: .monday), entry: entry)
                            DayView(model: WeekendDayModel(day: .tuesday), entry: entry)
                            DayView(model: WeekendDayModel(day: .wednesday), entry: entry)
                           
                           
                        }).padding(.horizontal, 12)
                        HStack(spacing: 0,content: {
                           
                            DayView(model: WeekendDayModel(day: .thursday), entry: entry)
                            DayView(model: WeekendDayModel(day: .friday), entry: entry)
                            DayView(model: WeekendDayModel(day: .saturday), entry: entry)
                          
                           
                        }).frame(width: ( proxy.size.width - 24 ) * 3 / 4 )
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                        
                       
                    })
                }
                   default:
                       Text("Some other WidgetFamily in the future.")
                   }
            
            
            
           
            
          
            
        }
    }
}

@available(iOS 17.0, *)
struct DayView: View {
    
    var model: WeekendDayModel
    var entry: SourceImageEntry
    
    var imgSrc: ImageDataViewModel {
        entry.imgViewModel
    }
    var btnCLModel: ButtonCheckListModel {
        entry.btnChecklistModel
    }
    var actualName: String {
        entry.imgSrc.actualName
    }
    
    var routineType: RoutinMonitorType {
        entry.routineType
    }
    
    var id_day: Int {
        model.day.rawValue
    }
    
    var currentIndexCheckImage: Int {
        entry.imgViewModel.currentCheckImageRoutine[id_day]
    }
    
    var imageButton: UIImage {
        switch routineType {
        case .random:
            return imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
            btnCLModel.checkImage[currentIndexCheckImage] : btnCLModel.uncheckImage.shuffled().first ?? UIImage(named: AssetConstant.unchecklistButton)!
        case .single:
            return imgSrc.dateCheckListModel[id_day].isChecked ?
                  btnCLModel.checkImage.first ?? UIImage(named: AssetConstant.checklistButton)! : btnCLModel.uncheckImage.shuffled().first ?? UIImage(named: AssetConstant.unchecklistButton)!
        case .daily:
            if id_day > btnCLModel.checkImage.count - 1 {
                return btnCLModel.checkImage.first ?? UIImage(named: AssetConstant.unchecklistButton)!
            }
            
            return imgSrc.dateCheckListModel[id_day].isChecked ? btnCLModel.checkImage[id_day] : btnCLModel.uncheckImage.shuffled().first ?? UIImage(named: AssetConstant.unchecklistButton)!
        }
    }
    
    @Environment(\.widgetFamily) var family
    
    
    var body: some View {
        
        switch routineType {
        case .random:
            switch family {
            case .systemSmall :
                VStack(spacing: 2,content: {
                    Button(intent: RandomRoutinButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage: imageButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                        
                        
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 8).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            case .systemMedium:
                VStack(spacing: 2,content: {
                    Button(intent: RandomRoutinButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage: imageButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 10).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            case .systemLarge:
                VStack(spacing: 2,content: {
                    Button(intent: RandomRoutinButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage:  imageButton)
                        .resizable()
                        
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                        
                        
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 14).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            default:
                Text("No")
                
            }
        case .single, .daily:
            switch family {
            case .systemSmall :
                VStack(spacing: 2,content: {
                    Button(intent: SingleRoutineButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage: imageButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 8).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            case .systemMedium:
                VStack(spacing: 2,content: {
                    Button(intent: SingleRoutineButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage:  imageButton)
                        .resizable()
                        
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                        
                        
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 10).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            case .systemLarge:
                VStack(spacing: 2,content: {
                    Button(intent: SingleRoutineButtonIntent(id_day: id_day, id_name: actualName)) {
                        Image(uiImage:  imageButton)
                        .resizable()
                        
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                        
                        
                        
                    }.buttonStyle(.plain)
                    
                    Text(model.day.nameDay)
                      
                        .font(.system(size: 14).weight(.bold))
                        .foregroundColor(imgSrc.dateCheckListModel[model.day.rawValue].isChecked ?
                            .black : .black.opacity(0.7))
                        .fixedSize()
                }).frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            default:
                Text("No")
                
            }

        }
        
        
        
      

    }
}



