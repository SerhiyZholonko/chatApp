//
//  FileUploader.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import AVKit

struct FileUploader {
    //MARK: - upload image

    static func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let uid = Auth.auth().currentUser?.uid ?? "/profileImages/"
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/\(uid)/\(filename)")
        
        ref.putData(imageData) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let fileUrl = url?.absoluteString else { return }
                completion(fileUrl)
            }
        }
    }
    //MARK: - upload audio
    static func uploudeAudio(audionUrl: URL, complition: @escaping (String) -> Void) {
        let uid = Auth.auth().currentUser?.uid ?? "/profileImages/"
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/\(uid)/\(filename)")
        ref.putFile(from: audionUrl, metadata: nil){ metaData, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let fileURL = url?.absoluteString else { return }
                complition(fileURL)
            }
        }
    }
    //MARK: - upload video
    static func uploadVideo(url: URL,
                                      success : @escaping (String) -> Void,
                                      failure : @escaping (Error) -> Void) {

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        let storageRef = Storage.storage().reference().child("Videos").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        storageRef.downloadURL { (url, error) in
                            guard let fileURL = url?.absoluteString else {return}
                            success(fileURL)
                        }
                    }
            })
        }
    }
    
    static func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
 
    static func getImage (withImageURL imageURL: URL, completion: @escaping (UIImage) -> Void){
        SDWebImageManager.shared.loadImage(with: imageURL, options: .continueInBackground, progress: nil) { image, data, error, cashType, finised, url in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let image = image else {return}
            completion(image)
        }
        
    }
}
