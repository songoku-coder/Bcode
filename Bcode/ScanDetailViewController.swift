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
        
        
//        goWebButton.backgroundColor = UIColor.white // 背景色
//        goWebButton.layer.borderWidth = 0.5 // 枠線の幅
//        goWebButton.layer.borderColor = UIColor.blue.cgColor // 枠線の色
//        goWebButton.layer.cornerRadius = 10.0 // 角丸のサイズ
//        
        
        
        let likeButton = CustomButton()
        
        // サイズを変更する
        likeButton.frame = CGRect(x: 0, y: 613, width: 185, height: 54)
        
        likeButton.backgroundColor = UIColor.white // 背景色
        likeButton.layer.borderWidth = 0.5 // 枠線の幅
        likeButton.layer.borderColor = UIColor.blue.cgColor // 枠線の色
        likeButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        // ボタンのタイトルを設定
        likeButton.setTitle("Like It！❤️", for:UIControl.State.normal)
        likeButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        
        
        self.view.addSubview(likeButton)
        
        likeButton.argument = String(barcode)
        
        
        likeButton.addTarget(self, action: #selector(historyUpdate(_:)), for: .touchDown)
        

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
    
    
    
    
    
    //realm データ保存Update：收藏flg更新
    @objc func historyUpdate(_ sender: CustomButton){
        
        // (1)Realmインスタンスの生成
        let realm = try! Realm()

        // (2)クエリによるデータの取得
        let results = realm.objects(ScanHistory.self).filter("barcode == %@",  sender.argument!).first

        // (3)データの更新
        try! realm.write {
            
            if results?.want_flg == 0 {
               results?.want_flg = 1
               results?.updatedDate = NSDate() as Date
            }else{
               results?.want_flg = 0
               results?.updatedDate = NSDate() as Date
            }
            
        }
        
    }


}

// ボタンのカスタムクラス（ボタン押下時のSelectorの引数を使用する為に用意）:
//按下button把商品barcode传递给realm更新
class CustomButton:UIButton {
    // 引数として使用する
    var argument:String?
}


