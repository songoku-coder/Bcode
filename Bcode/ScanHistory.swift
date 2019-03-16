//
//  ScanHistory.swift
//  Bcode
//
//  Created by jian sun on 2019/03/14.
//  Copyright © 2019 jian sun. All rights reserved.
//

import Foundation
import RealmSwift



/*
 *scanhistory model
 *
 */
class ScanHistory: Object
{
    // barcode
    @objc dynamic var barcode : String = ""
    // 商品名
    @objc dynamic var product : String = ""
    // 値段
    @objc dynamic var price : String = ""
    // 詳細
    @objc dynamic var detail : String = ""
    //img url
    @objc dynamic var imgurl : String = ""
    //product url
    @objc dynamic var producturl : String = ""
    //flg
    @objc dynamic var want_flg : Int = 0
    // 作成日時
	@objc dynamic var createdDate : Date = NSDate() as Date

    // 更新日時
    @objc dynamic var updatedDate : Date = NSDate() as Date
    
}

