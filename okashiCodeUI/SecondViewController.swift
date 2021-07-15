import UIKit

// ViewControllerを継承する
class SecondViewController: ViewController {

    // MARK: Views

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景色を変更
        self.view.backgroundColor = UIColor.red
        // ラベルの文字を変更
        self.label.text = "みんなは何か書いた？"
        // ボタンの文字を変更
        self.button.setTitle("Back", for: .normal)
    }

    @objc override func buttonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
