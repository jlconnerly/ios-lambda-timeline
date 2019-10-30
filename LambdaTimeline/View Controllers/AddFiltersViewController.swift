//
//  AddFiltersViewController.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreImage

class AddFiltersViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurSlider: UISlider!
    
    private let context = CIContext(options: nil)
    
    private let filter = CIFilter(name: "CIBoxBlur")!
    
    var image: UIImage?
    
    var originalImage: UIImage? {
        didSet {
                guard let image = originalImage else { return }
                imageView.image = image
                var scaledSize = imageView.bounds.size // gets the physical number of pixels on screen
                
                // 1x 2x 3x
                let scale = UIScreen.main.scale
                
                scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
                scaledImage = image.imageByScaling(toSize: scaledSize)
        }
    }

    var scaledImage: UIImage? {
        didSet {
            updateImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = image
    }
    
    private func filterImage(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(blurSlider.value, forKey: "inputRadius")
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // render the image
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
    
        private func updateImage() {
        if let image = scaledImage {
            imageView.image = filterImage(image: image)
        }
    }
    
    @IBAction func blurSliderDidChangeValue(_ sender: UISlider) {
        updateImage()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        guard let image = imageView.image else { return }
        NotificationCenter.default.post(name: .doneApplyingFilters, object: self, userInfo: ["image": image])
    }
    
}
