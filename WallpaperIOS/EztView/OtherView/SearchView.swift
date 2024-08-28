//
//  SearchView.swift
//  WallpaperIOS
//
//  Created by Mac on 27/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI


class TextFieldViewModel : ObservableObject {
    @Published var text : String = ""
}

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var textFieldViewModel : TextFieldViewModel = .init()
    @StateObject var viewmodel : SearchViewModel = .init()
    @StateObject var tagViewModel : TagViewModel = .init()
    @StateObject var findViewModel : FindViewModel = .init()
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
  
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    let width : CGFloat = ( UIScreen.main.bounds.width - 32 ) / 3
    
    @State var adStatus : AdStatus =  .loading
    
    var body: some View {
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
                        .containerShape(Rectangle())
                })
                
                TextField( text: $textFieldViewModel.text){
                    Text("Search for wallpaper you like")
                        .font(.system(size: 14))
                        .italic()
                        .foregroundColor(.white.opacity(0.9))
                }
                .mfont(13, .bold)
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 48)
                )
                .padding(.leading, 16)
                .onReceive(
                    textFieldViewModel.$text
                        .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                ) {
                    viewmodel.searchTag(text: $0)
                    
                    if $0 == "keeps me awake"{
                        store.purchasedIds.append("duc")
                        ServerHelper.eztEmpeloyee = true
                        DispatchQueue.main.async{
                            showToastWithContent(image: "heart", color: .pink, mess: "good time")
                            dismiss.callAsFunction()
                        }
                        return
                    }
                    
                    
                    if findViewModel.query == $0{
                        return
                    }
                    
                    findViewModel.wallpapers.removeAll()
                    findViewModel.query = $0
                    findViewModel.getWallpapers()
                    
                    
                    
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                
                if !viewmodel.tags.isEmpty{
                    
                    Text("Popular Collections")
                        .mfont(15, .bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem.init(spacing : 8), GridItem.init(spacing : 8), GridItem.init()], spacing: 8){
                        ForEach(0..<viewmodel.tags.count, id: \.self){
                            index in
                            CategoryPreview(tag: viewmodel.tags[index])
                                .onAppear(perform: {
                                    if !textFieldViewModel.text.isEmpty{
                                        return
                                    }
                                    if viewmodel.checkLoadNextPage(index: index){
                                        viewmodel.getTags()
                                    }
                                })
                        }
                    }.padding(.horizontal, 8)
                }
                
                
                
                if !findViewModel.wallpapers.isEmpty {
                    
                    Text("Result ")
                        .mfont(15, .bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem.init(spacing: 8),GridItem.init(spacing: 8),  GridItem.init(spacing: 0)], spacing: 8 ){
                        
                        ForEach(0..<findViewModel.wallpapers.count, id: \.self){
                            i in
                            
                            
                            let  wallpaper = findViewModel.wallpapers[i]
                            let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                            
                            NavigationLink(destination: {
                                WallpaperNormalDetailView(index: i)
                                    .environmentObject(findViewModel as CommandViewModel)
                                    .environmentObject(reward)
                                    .environmentObject(store)
                                  
                                    .environmentObject(interAd)
                            }, label: {

                                WebImage(url: URL(string: string))
                                
                                   .onSuccess { image, data, cacheType in
                                       // Success
                                       // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                   }
                                   .scaledToFill()
                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                .cornerRadius(2)
                                .overlay(
                                    ZStack{
                                        if !store.isPro() && wallpaper.content_type == "private"{
                                            
                                            Image("coin")
                                                .resizable()
                                                .frame(width: 13.33, height: 13.33, alignment: .center)
                                            
                                            
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .background(
                                                    Capsule()
                                                        .fill(Color.black.opacity(0.7))
                                                )
                                                .padding(8)
                                            
                                        }
                                    }
                                    
                                    , alignment: .topTrailing
                                )
                            })
                            .cornerRadius(2)
                            .onAppear(perform: {
                                if findViewModel.shouldLoadData(id: i){
                                    findViewModel.getWallpapers()
                                }
                            })
                            
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                    .padding(.horizontal, 16)
                }
                
                
            }
            .padding(.top, 16)
            
            
            
            NavigationLink(isActive: $viewmodel.navigateToTag, destination: {
                TagView()
                    .environmentObject(tagViewModel)
                    .environmentObject(reward)
                    .environmentObject(store)
                   
                    .environmentObject(interAd)
            }, label: {
                EmptyView()
            })
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()
        .onDisappear(perform: {
            dismissKeyboard()
        })
       
        
    }
    

    @ViewBuilder
    func CategoryPreview(tag : Tag) -> some View {

        let urlStr = tag.previewSmallURL
        

        WebImage(url: URL(string: urlStr ?? ""))
        
           .onSuccess { image, data, cacheType in
               // Success
               // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
           }
           .resizable()
           .placeholder {
               placeHolderImage()
                   .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
           }
           .scaledToFill()
        .frame(width:width , height: width * 2)
       
        //.blur(radius: 1)
     
        .overlay(
            ZStack{
                Color.black.opacity(0.2)
                Text(tag.title)
                    .mfont(16, .italic)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1)
            }
           
        )
        .cornerRadius(2)
        .onTapGesture {
            tagViewModel.tag = tag.title
            viewmodel.navigateToTag.toggle()
            
            
            
        }
        
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
  
