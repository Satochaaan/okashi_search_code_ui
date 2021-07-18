//
//  ViewController.swift
//  okashiCodeUI
//
//  Created by 川野智史 on 2021/07/11.
//

import UIKit
import SafariServices

class ViewController: UIViewController,
                      UISearchBarDelegate,
                      UITableViewDataSource,
                      UITableViewDelegate,
                      SFSafariViewControllerDelegate{
    
    let searchBar = UISearchBar();
    var okashiTableView = UITableView();
    
    // お菓子のリスト(タプル型)
    var okashiList : [(name:String, maker:String, link:URL, image:URL)] = []
    

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        self.view.backgroundColor = UIColor.white
        
        // 検索バー配置
        self.view.addSubview(self.searchBar)
        self.searchBar.delegate = self
        self.searchBar.placeholder = "お菓子の名前を入力してください"
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // お菓子テーブル配置
        self.okashiTableView.delegate = self
        self.okashiTableView.dataSource = self
        self.okashiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.okashiTableView)
        self.okashiTableView.translatesAutoresizingMaskIntoConstraints = false
        self.okashiTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.okashiTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.okashiTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.okashiTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            print(searchWord)
            // お菓子検索実行
            self.searchOkashi(keyword: searchWord)
        }
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を指定
        return okashiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        // お菓子タイトル
        cell.textLabel?.text = okashiList[indexPath.row].name
        // お菓子画像
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ハイライト解除
        tableView.deselectRow(at: indexPath, animated: true)
        // SFSafariViewを開く
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        // delegateの通知先を自分自身
        safariViewController.delegate = self
        // SafariViewを開く
        present(safariViewController, animated: true, completion: nil)
    }
    
    // MARK: - SFSafariView
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    func searchOkashi(keyword : String) {
        // お菓子の検索キーワードをURLエンコード
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r")
        else {
            return
        }
        print(req_url)
        
        // リクエスト作成
        let req = URLRequest(url: req_url)
        // セッション生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req) { data, response, error in
            session.finishTasksAndInvalidate()
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                // お菓子の情報が取得できているか確認
                self.okashiList.removeAll()
                if let items = json.item {
                    for item in items {
                        if let name = item.name, let maker = item.maker, let link = item.url, let image = item.image {
                            let okashi = (name,maker,link,image)
                            self.okashiList.append(okashi)
                        }
                    }
                    
                    // tableViewの更新
                    self.okashiTableView.reloadData()
                    
                    if let okashidbg = self.okashiList.first {
                        print("----------")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
            } catch {
                print("エラーが出ました")
            }
        }
        // ダウンロード開始
        task.resume()
    }
    
}

// MARK: - JSON Struct
struct ItemJson: Codable {
    let name: String?
    let maker: String?
    let url: URL?
    let image: URL?
}

struct ResultJson: Codable {
    let item:[ItemJson]?
}
