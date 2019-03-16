//
//  SecondViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/04.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    
    let results = try! Realm().objects(ScanHistory.self).filter("want_flg == 1")
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WantCell", for: indexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = results[indexPath.row].product
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = results[indexPath.row].barcode+";"+results[indexPath.row].product+";"+results[indexPath.row].imgurl+";"+results[indexPath.row].detail+";"+results[indexPath.row].price+";"+results[indexPath.row].barcode+";"+results[indexPath.row].barcode+";"
        
        //ここに遷移処理を書く
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "historydetail") as! HistoryDetailViewController
        vc.text1 = message
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // TableViewのCellの削除を行った際に、Realmに保存したデータを削除する
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
//                let realm = try Realm()
//                try realm.write {
//                    realm.delete(self.results[indexPath.row])
//                }
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
            tableView.reloadData()
        }
    }
    

}

