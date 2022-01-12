//
//  ResultPageViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 04/01/22.
//

import UIKit
import CoreML


class ResultPageViewController: UIViewController {
    
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var rekomendasiTableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet  var captureResult: UIImageView!
     
    var filteredData: [Content] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Nav Bar
        navigationController?.title = "Hasil"
        
        //PassingData & Analyze Image
        let image = ImageModel.shared.image
        captureResult.image = image
        analyzeImage(image: image)
        
//        rekomendasiTableView.register(UINib(nibName: "\(CardTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "cardCell")
//        rekomendasiTableView.delegate = self
//        rekomendasiTableView.dataSource = self
        
        
        
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
                let data = Content(image: UIImage(named: content.thumb) ?? UIImage(), label: content.title)
                self.filteredData.append(data)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        //var results: [Content] = []
        
        print(filteredData.count)
      
            
//        var new: [Content] = []
//        for content in Constant.shared.newest {
//            let data = Content(image: UIImage(named: content.thumb) ?? UIImage(), label: content.title)
//                new.append(data)
//            }
//            self.dummyContent.append(SectionModel(title: "Resep terbaru", content: new))
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        
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

//extension ResultPageViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = rekomendasiTableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
//        cell.tempSearch = filteredData[indexPath.section].content
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return filteredData[section].title
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
//        let sectionLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: sectionView.frame.width, height: 25))
//
//        sectionLabel.textColor = UIColor(named: "TextColor")
//        sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
//
//        sectionView.addSubview(sectionLabel)
//
//        return sectionView
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 190
//    }
//
//
//}

extension ResultPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(filteredData.count)
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

