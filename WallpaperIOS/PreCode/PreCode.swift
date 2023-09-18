//
//  PreCode.swift
//  WallpaperIOS
//
//  Created by Mac on 07/08/2023.
//

import SwiftUI
import Photos


struct PreCode: View {
    var body: some View {
        VStack(spacing : 0){
            ZStack(alignment: .trailing){
                Rectangle().fill(Color.yellow)
                    .frame(width: 112, height: 200)
                    .cornerRadius(8)
                Rectangle().fill(Color.red)
                    .frame(width: 122, height: 220)
                    .cornerRadius(8)
                    .padding(.trailing, 12)
                Rectangle().fill(Color.green)
                    .frame(width: 136, height: 240)
                    .cornerRadius(8)
                    .padding(.trailing, 24)
            }.frame(width: 160, height: 240)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .addBackground()
        
    }
    
    
    
    func createAlbum(albumName: String) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, error in
            if success {
                print("Album created successfully.")
              
            } else {
                showToastWithContent(image: "xmark", color: .red, mess: "Error, can't create Albumn")
            }
        }
    }

}


struct PreCode2: View {
    var body: some View {
        VStack(spacing : 0){
            ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing : 8){
                Rectangle().fill(Color.red).frame(width: 180, height: 320)
             
                    LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                        ForEach(1..<5, content: {
                            i in
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 88, height: 156)
                        })
                    })
                }
               
                
            }
            .frame(height: 320)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .addBackground()
        
    }
}


struct PreCode_Previews: PreviewProvider {
    static var previews: some View {
        PreCode2()
    }
}
