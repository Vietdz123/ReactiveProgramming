//
//  WidgetMainViewModel.swift
//  WallpaperIOS
//
//  Created by Duc on 25/10/2023.
//

import SwiftUI

enum FetchWidgetType : String , CaseIterable {
    case ALL = "Interactive Widget"
    case DigitalFriend = "Digital Friend"
    case Routine = "Rountine Monitor"
    case Sound = "Sound Widget"
    case Gif = "Gif Widget"
    case DecisionMaker = "Make Decision" 
    
    
}

class WidgetMainViewModel: ObservableObject {
    
    @Published var widgets : [EztWidget] = []
    @Published var currentOffset : Int = 0
    @Published var type : FetchWidgetType //= .ALL
    @Published var sort : SpSort //= .NEW
    @Published var sortByTop : SpTopRate
    
    
    
    init(type : FetchWidgetType = .ALL, sort : SpSort = .NEW, sortByTop : SpTopRate = .TOP_WEEK){
        self.type = type
        self.sort = sort
        self.sortByTop = sortByTop
    }
    
    func getWidgets(){
        let urlString = "\(APIHelper.WIDGET)\(getFetchWidgetType())&limit=\(AppConfig.limit)&offset=\(currentOffset)\(getSortParamStr())&all=1" // 
           
           guard let url  = URL(string: urlString) else {
               return
           }
           
        print("WidgetViewModel \(getFetchWidgetType()) url: \(url.absoluteString)")
         
           
           URLSession.shared.dataTask(with: url){
               data, _ ,err  in
               guard let data = data, err == nil else {
                   print("WidgetViewModel error")
                   return
               }
               print("WidgetViewModel has data")
               let itemsCurrentLoad = try? JSONDecoder().decode(EztWidgetHomeResponse.self, from: data)
               
               DispatchQueue.main.async {
                   self.widgets.append(contentsOf: itemsCurrentLoad?.data.data  ?? [])
                   self.currentOffset = self.currentOffset + AppConfig.limit
                   print("WidgetViewModel widgets count: \(self.widgets.count)")

               }
               
           }.resume()
    }
    
    func shouldLoadData(id : Int) -> Bool {
        return id == widgets.count - 5
    }
    
    
    func getFetchWidgetType() -> String {
        switch type {
        case .ALL:
            return ""
        case .DigitalFriend:
            return "&where=category_id+2"
        case .Routine:
            return "&where=category_id+3"
        case .Sound :
            return "&where=category_id+4"
        case .Gif:
            return "&where=category_id+5"
        case .DecisionMaker:
            return "&where=category_id+7"
        }
       
    }
    
    func getSortParamStr() -> String {
        if sort == .NEW{
            return "&order_by=id+desc"
        }else{
            if sortByTop == .TOP_WEEK {
                return "&order_by=daily_rating+desc,order+asc"
            }else{
                return "&order_by=monthly_rating+desc,id+desc"
            }
            
        }
       
    }
}

