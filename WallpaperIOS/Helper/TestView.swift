//
//  TestView.swift
//  WallpaperIOS
//
//  Created by Mac on 27/04/2023.
//

import SwiftUI

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct TestView: View {
    
    @State var offset : CGSize = .zero
    @State var isDraging : Bool = false
    
    @State var uiimage : UIImage?
    
    var custom : some View{
        ZStack{
            Image("test")
                .resizable()
                .aspectRatio( contentMode: .fit)
            
            Text("No")
                .frame(width: 200, height: 100)
                .background{
                    if isDraging{
                        Color.gray.opacity(0.6)
                    }
                }
                .offset(offset)
              
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            isDraging = true
                            withAnimation(.linear){
                                offset = value.translation
                            }
                        }
                        .onEnded{ value in
                            offset = value.translation
                            isDraging = false
                            print("OFFSET X \(offset.width) Y \(offset.height)")
                        }
                )
            
          
            
        }
    }
    
    var body: some View {
        VStack(spacing : 0){
            custom
            Button(action: {
                uiimage = custom.snapshot()
               
            }, label: {
               Text("Snap shot")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack(alignment: .top){
                
            if (uiimage != nil){
                Color.red
                
                Image(uiImage: uiimage!)
                    .resizable()
                    .frame(width: 200, height: 200)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
        )
                
        
        
       
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
