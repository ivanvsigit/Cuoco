//
//  ResultPageViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 04/01/22.
//

import UIKit
import CoreML


class ResultPageViewController: UIViewController {
    
    @IBOutlet weak var rekomenResep: UILabel!
    @IBOutlet weak var resultName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet  var captureResult: UIImageView!
     
    var filteredData: [Content] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Font
        resultName.font = UIFont(name: "Poppins-Medium", size: 22)
        rekomenResep.font = UIFont(name: "Poppins-SemiBold", size: 20)
        
        
        //Nav Bar
        navigationController?.title = "Hasil"
        
        //PassingData & Analyze Image
        let image = ImageModel.shared.image
        captureResult.image = image
        analyzeImage(image: image)
        
        
        collectionView.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "cardCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchSearchData()
    }
    
    private func analyzeImage(image: UIImage?){
        let image = ImageModel.shared.image
        guard let buffer = image?.resize(size: CGSize(width: 299, height: 299))?.getCVPixelBuffer() else {
            return
        }
        
        do{
            let config = MLModelConfiguration()
            let model = try Vegetables_Identifier(configuration: config)
            let input = Vegetables_IdentifierInput(image: buffer)
            
            let output = try model.prediction(input: input)
            let text = output.classLabel
            resultName.text = text
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchSearchData(){
        guard let url = resultName.text else{
            return
        }
        API.shared.fetchSearchDataAPI(urlKey: url) {
            for content in Constant.shared.search {
                let data = Content(image: UIImage(data: Constant.shared.getImage(urlKey: content.thumb))!, label: content.title)
                self.filteredData.append(data)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        print(filteredData.count)
      
        
    }
    
}

extension UIImage {


    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 8, y: 8, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func getCVPixelBuffer() -> CVPixelBuffer? {
        guard let image = cgImage else {
            return nil
        }
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)
        
        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]
        
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            imageWidth,
            imageHeight,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary?,
            &pxbuffer
        )
            
        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(
                data: pxdata,
                width: imageWidth,
                height: imageHeight,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                space: rgbColorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            )
            
            if let _context = context {
                _context.draw(
                    image,
                    in: CGRect.init(
                        x: 0,
                        y: 0,
                        width: imageWidth,
                        height: imageHeight
                    )
                )
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer,flags);
                return nil
            }
            
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags) ;
            return _pxbuffer;
        }
        
        return nil
    }
}


extension ResultPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCollectionCell", for: indexPath) as! CardCollectionViewCell
        cell.tempModelCCol = filteredData[indexPath.row]
        cell.layer.cornerRadius = 10

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 150)
    }

}

