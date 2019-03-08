//
//  FirstViewController.swift
//  Bcode
//
//  Created by jian sun on 2019/03/04.
//  Copyright © 2019 jian sun. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // バーコードリーダーのモーダルが開くボタン
        let buttonSize: CGFloat = 100
        let button: UIButton = UIButton()
        button.frame = CGRect(x: (self.view.frame.width - buttonSize) / 2, y: (self.view.frame.height - buttonSize) / 2, width: buttonSize, height: buttonSize)
        button.backgroundColor = .blue
        button.setTitle("扫一下", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(taped(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // ボタンが押されたら呼ばれます
    @objc func taped(sender: UIButton) {
        self.present(BarCodeReaderVC(), animated: true, completion: nil)
    }
}
