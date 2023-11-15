//
//  WidgetListView.swift
//  WallpaperIOS
//
//  Created by Duc on 31/10/2023.
//

import SwiftUI

struct WidgetListView: View {
    
    @EnvironmentObject var viewModel : WidgetMainViewModel
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeVM : MyStore
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .containerShape(Rectangle())
            })
            Text("Widget".toLocalize())
                .foregroundColor(.white)
                .mfont(22, .bold)
                .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            if viewModel.type != .ALL {
                HStack(spacing : 12){
                    ForEach(SpSort.allCases, id: \.rawValue){
                        sort in
                        
                  
                            Text(sort.rawValue.toLocalize())
                                .mfont(13, .bold)
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width : 80, height: 28)
                              .background(
                                ZStack{
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                    
                                    if viewModel.sort == sort{
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                stops: [
                                                Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                                Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0, y: 1.38),
                                                endPoint: UnitPoint(x: 1, y: -0.22)
                                                )
                                            
                                            )
                                            .matchedGeometryEffect(id: "SORT", in: anim)
                                    }
                                    
                                }
                                
                              )
                              .contentShape(Rectangle())
                              .onTapGesture(perform: {
                                  if viewModel.sort == sort{
                                      return
                                  }
                                  
                                  withAnimation{
                                      viewModel.sort = sort
                                  }
                                  viewModel.currentOffset = 0
                                  viewModel.widgets.removeAll()
                                  viewModel.getWidgets()
                              })
                     
                        
                    }
                    
                    Spacer()
                }.padding( [.horizontal, .bottom] , 16)
            }
         
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing : 16 ,content: {
                    ForEach(0..<viewModel.widgets.count, id: \.self) { count in
                        let widget : EztWidget = viewModel.widgets[count]
                        
                        NavigationLink(destination: {
                            WidgetDetailView(widget: widget)
                                .environmentObject(storeVM)
                        }, label: {
                            ItemWidgetViewFull(widget: widget)
                                .overlay(alignment : .topTrailing){
                                    if !storeVM.isPro(){
                                        Image("crown")
                                            .resizable()
                                            .frame(width: 16, height: 16, alignment: .center)
                                            .padding(8)
                                    }
                                }
                              
                        }).onAppear(perform: {
                            if viewModel.shouldLoadData(id: count){
                                viewModel.getWidgets()
                            }
                        })
                        
                    }
                })
            }
            .refreshable {
                
            }
            
            
        
        
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
}

#Preview {
    WidgetListView()
}
