//
//  ThirdViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/04.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit
import RealmSwift

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var TableView: UITableView!
    
    private weak var refreshControl: UIRefreshControl!
    
    
    // 全データの取得
    let results = try! Realm().objects(ScanHistory.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePullToRefresh()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        refresh()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // (1)Realmインスタンスの生成
            let realm = try! Realm()
            
            // (2)クエリによるデータの取得
            let results2 = realm.objects(ScanHistory.self).filter("barcode == %@",results[indexPath.row].barcode)
            
            // (3)データの削除
            try! realm.write {
                realm.delete(results2)
            }
            
            
            TableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    // MARK: - Pull to Refresh
    private func initializePullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onPullToRefresh(_:)), for: .valueChanged)
        TableView.addSubview(control)
        refreshControl = control
    }
    
    @objc private func onPullToRefresh(_ sender: AnyObject) {
        refresh()
    }
    
    private func stopPullToRefresh() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Data Flow
    private func refresh() {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async {
                self.completeRefresh()
            }
        }
    }
    
    private func completeRefresh() {
        stopPullToRefresh()
        TableView.reloadData()
    }
    
    
    
    
}
