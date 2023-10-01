//
//  ExtensionChatViewController.swift
//  chatApp
//
//  Created by apple on 18.09.2023.
//

import UIKit


//MARK: - Aler func
extension ChatViewController {
   
   @objc  func handleCamera()  {
       imagePiker.sourceType = .camera
       imagePiker.mediaTypes = ["public.image", "public.movie"]
       present(imagePiker, animated: true)
   }
   @objc  func handleGallery() {
       imagePiker.sourceType = .savedPhotosAlbum
       imagePiker.mediaTypes = ["public.image", "public.movie"]
       present(imagePiker, animated: true)
   }
}



//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIAnimatable {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [weak self] in
            guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else { return }
            if mediaType == "public.image" {
                //Upload image
                guard let image = info[.editedImage] as? UIImage else { return }
                self?.uploadImage(withImage: image)
                
            } else {
                guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
                self?.uploadVideo(withVideoUrl: videoUrl)
                
            }
        }
    }
}

 //MARK: - upload media

extension ChatViewController {
    func uploadImage (withImage image: UIImage) {
        showLoadingAnimation()
        FileUploader.uploadImage(image: image) { [self] stringUrl in
            MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unReadCounter in
                MessageService.uploadMessage(imageUrl: stringUrl,currentUser: currentUser, unReadCounter: unReadCounter + 1, otherUser: otherUser) { error in
                    self.hideLoadingAnimation()
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
    }
    func uploadVideo(withVideoUrl url: URL ) {
        showLoadingAnimation()
        FileUploader.uploadVideo(url: url) { [self] url in
            MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unReadCounter in
                MessageService.uploadMessage(
                     videoUrl: url, currentUser: currentUser, unReadCounter: unReadCounter + 1, otherUser: otherUser) { [self] error in
                         hideLoadingAnimation()
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        } failure: { error in
            print(error.localizedDescription)
            return
        }

    }
}



 //MARK: -
extension ChatViewController {
    func  handleCurrentLocation() {
        FLocationManager.shared.start { info in
            guard let lat = info.latitude, let lng = info.longitude else { return }
            uploadLocation(lat: "\(lat)", lng: "\(lng)")
    }
    func handleGoogleMap() {
        
    }
    func uploadLocation (lat: String, lng: String){
        let locationURL = "https://www.google.com/maps/dir/?api=1&destination=\(lat),\(lng)"
        showLoadingAnimation()
        MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unReadCount in
            MessageService.uploadMessage(locationUrl: locationURL, currentUser: currentUser, unReadCounter: unReadCount + 1, otherUser: otherUser) { [self] error in
                hideLoadingAnimation()
                if let error = error {
                    print(error.localizedDescription)
                }
                print(locationURL)
            }
        }
        }
    }
}
