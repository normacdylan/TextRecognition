//
//  ViewController.swift
//  TextRecognition
//
//  Created by August Posner on 2018-04-12.
//  Copyright © 2018 August Posner. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*
        if let tesseract = G8Tesseract(language: "eng+swe") {
            tesseract.delegate = self
            tesseract.image = UIImage(named: "textTv")?.g8_blackAndWhite()
            tesseract.recognize()
            
            textView.text = tesseract.recognizedText
        } */
        
        
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition progress: \(tesseract.progress)%")
    }
    
    @IBAction func pressedChoose(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        let actionSheet = UIAlertController(title: "Image", message: "Choose a source", preferredStyle: .actionSheet )
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
    
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
    
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
    
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        if let text = analyzeImage(image) {
            textView.text = text
        } else {
            textView.text = "Something went wrong :("
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func analyzeImage(_ image: UIImage) -> String? {
        if let tesseract = G8Tesseract(language: "eng+swe") {
            tesseract.delegate = self
          //  tesseract.image = image.g8_blackAndWhite()
        //    let resizedImage = resizeImage(image: image, newWidth: 700)
            tesseract.image = image.g8_grayScale()
            tesseract.recognize()
            
            return tesseract.recognizedText
        }
        return nil
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

