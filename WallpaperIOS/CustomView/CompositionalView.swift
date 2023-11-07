//
//  CompositionalView.swift
//  WallpaperIOS
//
//  Created by Mac on 16/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

enum LayoutType {
    case type1
    case type2
    case type3
}

struct CompositionalView<Content, Content2 ,Item, ID> : View where Content : View, Content2 : View, ID : Hashable, Item : RandomAccessCollection, Item.Element : Hashable {
    
    var content : (Item.Element) -> Content
    var content2: (Int) ->  Content2
    var items : Item
    var id : KeyPath<Item.Element, ID>
    var spacing : CGFloat
    let h = ( UIScreen.main.bounds.width - 48 ) * 2 / 3
    

  
    
    init(items: Item
         ,id: KeyPath<Item.Element, ID>
         ,spacing:CGFloat = 8
         ,@ViewBuilder content : @escaping (Item.Element) -> Content
         ,@ViewBuilder content2: @escaping (Int) ->   Content2
    ) {
        self.content = content
        self.content2 = content2
        self.items = items
        self.id = id
        self.spacing = spacing
    }
    
    var body: some View {
        LazyVStack(spacing: spacing){
            ForEach(Array(generateColumn().enumerated()), id: \.element){
              index,  row in
              
                RowView( row: row)
                   
                if layoutType(row: row) == .type3 {
                   
                   content2(Int(( index + 1 ) / 3))
                       
                   
                }
            }
        }
    }
    
  
    
    func layoutType(row : [Item.Element]) -> LayoutType{
        let index = generateColumn().firstIndex{ item in
            return item == row
        } ?? 0
        
        var types : [LayoutType]  = []
        generateColumn().forEach{
            _ in
            if types.isEmpty{
                types.append(.type1)
            }else if types.last == .type1{
                types.append(.type2)
                
            }else if types.last == .type2 {
                types.append(.type3)
            }else if types.last == .type3 {
                types.append(.type1)
            }else{
                
            }
        }
        return types[index]
        
    }
    
   
        
        
    @ViewBuilder
    func RowView(row : [Item.Element]) -> some View{
        GeometryReader{
            proxy in
            let width = proxy.size.width
            let height = ( proxy.size.height - spacing ) / 2
            let type = layoutType(row: row)
            let columnWidth = (width > 0 ? ((width - ( spacing * 2 ) ) / 3) : 0)
            
            
            HStack(spacing : spacing){
                if type == .type1 {
                    VStack(spacing : spacing){
                        SafeRow(row: row, index: 0)
                            .frame( height: height)
                        SafeRow(row: row, index: 1)
                            .frame( height: height)
                    }.frame(width: columnWidth)
                    SafeRow(row: row, index: 2)
                    
                    
                   
                }
                if type == .type2{
                    HStack(spacing : spacing){
                        SafeRow(row: row, index: 2)
                            .frame(width: columnWidth)
                        SafeRow(row: row, index: 1)
                            .frame(width: columnWidth)
                        SafeRow(row: row, index: 0)
                            .frame(width: columnWidth)
                    }
                }
                if type == .type3{
                    SafeRow(row: row, index: 0)
                    VStack(spacing : spacing){
                        SafeRow(row: row, index: 1)
                            .frame( height: height)
                        SafeRow(row: row, index: 2)
                            .frame( height: height)
                    }.frame(width: columnWidth)
                    
                    
                    
                }
                
            }
        }.frame(height: layoutType(row: row) ==  .type1 || layoutType(row: row) == .type3 ? h * 2 + spacing : h)
            .clipped()
    }
    
    @ViewBuilder
    func SafeRow(row : [Item.Element], index : Int) -> some View{
        if (row.count - 1) >= index{
            content(row[index])
        }
    }
    
    func generateColumn() -> [[Item.Element]]{
        var columns : [[Item.Element]] = []
        var row : [Item.Element] = []
        
        for item in items{
            if row.count == 3 {
                columns.append(row)
                row.removeAll()
                row.append(item)
            }else{
                row.append(item)
            }
        }
        
        columns.append(row)
        row.removeAll()
        return columns
        
        
    }
}




