//
//  ScanDetailViewController.swift
//  显示商品详细信息
//  1.商品图片
//  2.商品名
//  3.商品价格
//  4.商品说明
//  5.收藏按钮
//  6.官网按钮：还没有code
//  7.返回按钮：
//  8.分享按钮：还没有code
//
//
//  *************待加功能*********************
//  1.上下滑动看具体商品说明
//  
//
//
//
//
//  Created by jian sun on 2019/03/06.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit
import RealmSwift
import HeartButton

class ScanDetailViewController: UIViewController {

    // 简介
    @IBOutlet weak var label1: UILabel!
    
    
    //response
    var text1:String!
    //商品名
    @IBOutlet weak var label2: UILabel!
    
    
    //价格
    @IBOutlet weak var priceLabel: UILabel!
    
    
    //显示商品图片
    @IBOutlet weak var image1: UIImageView!
    
    
    
    //返回button
    
    @IBAction func backButton(_ sender: Any) {
         self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var goWebButton: UIButton!
    
    
    @IBOutlet weak var heartButton: HeartButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //response分析：data:日本商品名；中国商品名；画像URL；値段；レビュー
        let dataArray = text1.split(separator: ";")

//        let jpPro = dataArray[0]
        let znPro = dataArray[1]
        let img   = String(dataArray[2])
        let detail = String(dataArray[3])
        
        let price = String(dataArray[4])
        
        let barcode = dataArray[6]


        let product_name = znPro
        
        let product_detail = "简介："+detail

        
        //画像表示
        let image:UIImage = getImageByUrl(url:img)
        image1.image = image

        //商品名表示
        label2.text = String(product_name)
        label2.sizeToFit()
        
        //値段
        priceLabel.text = "官方指导价格: "+price + "日元"
        priceLabel.sizeToFit()

        //简介表示
        label1.text = String(product_detail)
        label1.sizeToFit()
        
        
        
        //初期heartbutton設定
        
        // (1)Realmインスタンスの生成
        let realm = try! Realm()
        
        // (2)クエリによるデータの取得
        let results = realm.objects(ScanHistory.self).filter("barcode == %@",  barcode).first
        
        
        if results?.want_flg == 1 {
            self.heartButton.setOn(true, animated: true)
        }
        
        
        self.heartButton.stateChanged = { sender, isOn in
            if isOn {
                // selected
                
                // (2)クエリによるデータの取得
                let results = realm.objects(ScanHistory.self).filter("barcode == %@",  barcode).first
                
                // (3)データの更新
                try! realm.write {
                    
                    if results?.want_flg == 0 {
                        results?.want_flg = 1
                    }
                    
                }
                
                
            } else {
                // unselected
                
                // (2)クエリによるデータの取得
                let results = realm.objects(ScanHistory.self).filter("barcode == %@",  barcode).first
                
                // (3)データの更新
                try! realm.write {
                    
                    if results?.want_flg == 1 {
                        results?.want_flg = 0
                    }
                    
                }
            }
        }
        

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

