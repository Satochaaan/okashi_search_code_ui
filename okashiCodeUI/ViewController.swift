//
//  ViewController.swift
//  okashiCodeUI
//
//  Created by 川野智史 on 2021/07/11.
//

import UIKit

class ViewController: UIViewController {
    
    let label = UILabel()
    let button = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 背景色変更
        self.view.backgroundColor = UIColor.green
        
        // ラベル配置
        self.label.text = "label置いてみた!!!"
        self.label.translatesAutoresizingMaskIntoConstraints = false
        // ラベルをviewに設置
        self.view.addSubview(self.label)
        // ラベルの位置を設定
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // ボタン配置
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.setTitle("Next", for: .normal)
        self.button.addTarget(self, action: #selector(self.buttonDidTap(_:)), for: .touchUpInside)
        self.button.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        
        
    }

    // ボタンタップ処理
    @objc func buttonDidTap(_ sender: UIButton) {
        let secondViewController = SecondViewController()
        self.present(secondViewController, animated: true, completion: nil)
    }
}

