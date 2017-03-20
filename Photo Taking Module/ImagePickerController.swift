//
//  UITakePhotoController.swift
//
//  Created by daniel shen on 4/16/15.
//  Copyright (c) 2015 Daniel Shen. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerController: UIImagePickerController {
    
    var imagePickerDelegate: ImagePickerControllerDelegate? = nil
    var imageDelegate: ImageDelegate?
    var canTakePhoto: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.sourceType == .camera {
            canTakePhoto = isCameraAvailable() && doesCameraSupportTakingPhotos()
            // enable all standard camera UI if set to YES
            self.showsCameraControls = canTakePhoto
        }
        
        self.mediaTypes = [kUTTypeImage as String]
        self.allowsEditing = true
        imageDelegate = ImageDelegate()
        imageDelegate?.parent = self
        self.delegate = imageDelegate!
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func cameraSupportsMedia(_ mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool {
        
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType) 
        
        if let types = availableMediaTypes{
            for type in types{
                if type == mediaType {
                    return true
                }
            }
        }
        
        return false
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as NSString as String, sourceType: .camera)
    }
    
    
    class ImageDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController?
        
        func imageWasSavedSuccessfully(_ image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
            
            picker.dismiss(animated: true, completion: nil)
            
            if let type:AnyObject = mediaType {
                
                if type is String {
                    
                    let stringType = type as! String
                    
                    if stringType == (kUTTypeImage as NSString) as String {
                        
                        var theImage: UIImage!
                        
                        if picker.allowsEditing {
                            theImage = info[UIImagePickerControllerEditedImage] as! UIImage
                        } else {
                            theImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                        }
                        
                        let currentMillSeconds = Date.timeIntervalSinceReferenceDate * 1000
                        let fileName = currentMillSeconds.description.components(separatedBy: ".")[0] + ".jpg"
                        let imageData = UIImageJPEGRepresentation(theImage, CGFloat(Settings.ImageQuality))
                            
                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                        let documentsDirectory = paths.object(at: 0) as! NSString
                        let path = documentsDirectory.appendingPathComponent(fileName)
                        // write imageData to URI
                        try? imageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])
                        
                        DispatchQueue.main.async {
                            
                            self.parent!.imagePickerDelegate!.onUseButtonClick(self, fileName: fileName, image: imageData!)
                            
                        }
                    }
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent!.imagePickerDelegate!.onCancelPhotoButtonClick(self)
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
