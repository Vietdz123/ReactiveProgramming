//
//  CropView.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI

struct CropView: View {
    var image: UIImage
//    @Binding var cropSize: CGSize
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var interacting: Bool = false
    var onEdit: (UIImage?) -> ()
    var body: some View {
        ImageView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(eztGradientHori, lineWidth: 4)
                
            )
            .cornerRadius(16)
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        GeometryReader { geo in
            let size = geo.size
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .overlay(content: {
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .named("CROPVIEW"))
                        Color.clear
                            .onChange(of: interacting) { newValue in
                                if !newValue {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                        }
                                        
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                        }
                                        
                                        if rect.maxX < size.width {
                                            print(rect.maxX)
                                            offset.width = (rect.minX - offset.width)
                                            print(rect.maxX)
                                        }
                                        
                                        if rect.maxY < size.height {
                                            offset.height = (rect.minY - offset.height)
                                        }
                                    }
                                    
                                    lastStoredOffset = offset
                                    let uiImage = ImageView().frame(width: size.width, height: size.height).clipped().asUIImage
                                     
                                        
                                    onEdit(uiImage)
                                    
                                }
                            }
                    }
                })
                .frame(width: size.width, height: size.height)
        }
        .scaleEffect(scale)
        .offset(x: offset.width, y: offset.height)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($interacting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($interacting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        print(scale)
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
//        .onAppear(perform: {
//          onEdit(image)
//        })
//        .frame(width: cropSize.width, height: cropSize.height)
    }
    
    
}

extension View{
    var asUIImage: UIImage {
            let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.top))
            let view = controller.view
            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
            view?.backgroundColor = .clear
            
            let format = UIGraphicsImageRendererFormat()
            let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
}
