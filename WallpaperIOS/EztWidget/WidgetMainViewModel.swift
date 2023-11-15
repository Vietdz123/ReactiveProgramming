//
//  WidgetMainViewModel.swift
//  WallpaperIOS
//
//  Created by Duc on 25/10/2023.
//

import SwiftUI

enum FetchWidgetType {
    case ALL
    case DigitalFriend
    case Routine
    
    
}

class WidgetMainViewModel: ObservableObject {
    
    @Published var widgets : [EztWidget] = []
    @Published var currentOffset : Int = 0
    @Published var type : FetchWidgetType = .ALL
    @Published var sort : SpSort = .NEW
   
   
    
    
    init(){
        
    }
    
    func getWidgets(){
        let urlString = "https://widget.eztechglobal.com/api/v1/widgets?with=category+id,name-apps+id,name-tags+id,name\(getFetchWidgetType())&limit=\(AppConfig.limit)&offset=\(currentOffset)\(getSortParamStr())"
           
           guard let url  = URL(string: urlString) else {
               return
           }
           
        print("WidgetViewModel url: \(url.absoluteString)")
         
           
           URLSession.shared.dataTask(with: url){
               data, _ ,err  in
               guard let data = data, err == nil else {
                   print("WidgetViewModel error")
                   return
               }
               print("WidgetViewModel has data")
               let itemsCurrentLoad = try? JSONDecoder().decode(EztWidgetResponse.self, from: data)
               
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
        }
       
    }
    
    func getSortParamStr() -> String {
        if sort == .NEW{
            return "&order_by=id+desc"
        }else{
            return "&order_by=daily_rating+desc,order+asc"
        }
       
    }
}

