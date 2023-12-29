//
//  ImagePicker.swift
//  EztGenArt
//
//  Created by Duc on 14/12/2023.
//

import SwiftUI




struct ImagePickerView: UIViewControllerRepresentable {
 
    @Binding var showImagePicker : Bool
    let onTakePhotoSuccess : (UIImage?) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
       
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
              
                parent.onTakePhotoSuccess(uiImage)
                
            }else{
                parent.onTakePhotoSuccess(nil)
            }
           
           
            parent.showImagePicker = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
        }
    }
}
