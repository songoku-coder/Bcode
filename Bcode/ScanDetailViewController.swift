//
//  ScanDetailViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/06.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit

class ScanDetailViewController: UIViewController {

    // 简介
    @IBOutlet weak var label1: UILabel!
    //response
    var text1:String!
    //商品名
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //response分析：data:日本商品名；中国商品名；画像URL
        let dataArray = text1.split(separator: ";")

//        let jpPro = dataArray[0]
        let znPro = dataArray[1]
        let img   = String(dataArray[2])
        let detail = String(dataArray[3])


//        let product = "日本名："+jpPro+"\n"+"中文名："+znPro+"\n"+"\n"+"简介："+detail

        let product_name = "中文名："+znPro
        
        let product_detail = "简介："+detail

        
        //画像表示
        let image:UIImage = getImageByUrl(url:img)
        image1.image = image

        //商品名表示
        label2.text = String(product_name)

        //简介表示
        label1.text = String(product_detail)

    }
    
    
    //画像表示
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }

}
