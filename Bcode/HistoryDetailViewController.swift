//
//  HistoryDetailViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/16.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryDetailViewController: UIViewController {

    //response
    var text1:String!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var goWebButton: UIButton!
    
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
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
        
        
        goWebButton.backgroundColor = UIColor.white // 背景色
        goWebButton.layer.borderWidth = 0.5 // 枠線の幅
        goWebButton.layer.borderColor = UIColor.blue.cgColor // 枠線の色
        goWebButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        
        
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
    
    
    
    
    
    //realm データ保存Update
    @objc func historyUpdate(_ sender: HistoryCustomButton){
        
        // (1)Realmインスタンスの生成
        let realm = try! Realm()
        
        // (2)クエリによるデータの取得
        let results = realm.objects(ScanHistory.self).filter("barcode == %@",  sender.argument!).first
        
        // (3)データの更新
        try! realm.write {
            
            if results?.want_flg == 0 {
                results?.want_flg = 1
            }else{
                results?.want_flg = 0
            }
            
        }
        
    }
    
    
}

// ボタンのカスタムクラス（ボタン押下時のSelectorの引数を使用する為に用意）
class HistoryCustomButton:UIButton {
    // 引数として使用する
    var argument:String?
}

