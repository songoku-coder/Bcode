//
//  ScanDetailViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/06.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit

class ScanDetailViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    var text1:String!
    
    @IBOutlet weak var image1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image:UIImage = getImageByUrl(url:"http://nanashino-bijin.com/image/44885")
        
        image1.image = image

        
        label1.text = text1

    }
    
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
