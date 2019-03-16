import UIKit
import AVFoundation
import RealmSwift

class BarCodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // カメラやマイクの入出力を管理するオブジェクトを生成
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // カメラやマイクのデバイスそのものを管理するオブジェクトを生成（ここではワイドアングルカメラ・ビデオ・背面カメラを指定）
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        
        // ワイドアングルカメラ・ビデオ・背面カメラに該当するデバイスを取得
        let devices = discoverySession.devices
        
        //　該当するデバイスのうち最初に取得したものを利用する
        if let backCamera = devices.first {
            do {
                // QRコードの読み取りに背面カメラの映像を利用するための設定
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    
                    // 背面カメラの映像からQRコードを検出するための設定
                    let metadataOutput = AVCaptureMetadataOutput()
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        // 読み取りたいバーコードの種類を指定
                        // .ean13 は本の書籍などに使用されるバーコード
                        // .qr はQRコード、などなど
                        metadataOutput.metadataObjectTypes = [.ean13]
                        
                        // 読み取り可能エリアの設定を行う
                        // 画面の横、縦に対して、左が10%、上が40%のところに、横幅80%、縦幅20%を読み取りエリアに設定
                        let x: CGFloat = 0.1
                        let y: CGFloat = 0.4
                        let width: CGFloat = 0.8
                        let height: CGFloat = 0.2
                        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                        
                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = self.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        self.view.layer.addSublayer(previewLayer)
                        
                        // 読み取り可能エリアに赤い枠を追加する
                        let detectionArea = UIView()
                        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
                        detectionArea.layer.borderColor = UIColor.red.cgColor
                        detectionArea.layer.borderWidth = 3
                        view.addSubview(detectionArea)
                        
                        // 閉じるボタン
                        let closeBtn:UIButton = UIButton()
                        //下部に表示
                        closeBtn.frame = CGRect(x:((self.view.bounds.width-320)/2),y:(self.view.bounds.height-50),width:320,height:50)
                        closeBtn.setTitle("关闭", for: UIControl.State.normal)
                        closeBtn.backgroundColor = UIColor.lightGray
                        closeBtn.addTarget(self, action: #selector(closeTaped(sender:)), for: .touchUpInside)
                        self.view.addSubview(closeBtn)
                        
                        // 読み取り開始
                        self.session.startRunning()
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            
            // バーコードの内容が空かどうかの確認
            if metadata.stringValue == nil { continue }
            
            //読み込み中止
            self.session.stopRunning()
            
            //get request
            let url = URL(string: "http://loveme.starfree.jp/search/ItemSearchForm.php?query="+metadata.stringValue!)
            let request = URLRequest(url: url!)
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                    
                    // JSONをデコード
                    let productInfo = try! JSONDecoder().decode(Product.self, from: data)
                    
                    // 結果を表示してみる.
//                    print(productInfo.data)  // Munesada
                    
                    let dataArray = productInfo.data.split(separator: ";")
                    
                    //        let jpPro = dataArray[0]
                    let znPro = dataArray[1]
                    let img   = String(dataArray[2])
                    let detail = String(dataArray[3])
                    
                    let price = String(dataArray[4])
                    
                    
                    //realmに保存
                    self.historyInsert(barcode: metadata.stringValue!,product: String(znPro),price: price,detail: detail,imgurl: img)

                    //次の画面に表示
                    self.performSelector(onMainThread: #selector(self.display), with:productInfo.data + ";" + metadata.stringValue!, waitUntilDone: false)
                }
            }.resume()
            
        }
            
    }
    
    // 閉じるが押されたら呼ばれます
    @objc func closeTaped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //文字列次画面に表示
    @objc func display(message:String){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "detail") as! ScanDetailViewController
        vc.text1 = message
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //json文字列decode
    struct Product: Codable {  // Codableインターフェースを実装する
        let data: String
    }
    
    //realm データ保存INSERT
    @objc func historyInsert(barcode:String,product:String,price:String,detail:String,imgurl:String){
        
        // (1)選手データの作成
        let history = ScanHistory()
        
        history.barcode = barcode
        history.product = product
        history.price = price
        history.detail = detail
        history.imgurl = imgurl
        
        
        // (2)データの追加
        let realm = try! Realm()
        
        // (2)クエリによるデータの取得
        let results = realm.objects(ScanHistory.self).filter("barcode == %@", barcode).first

        
        try! realm.write {
            if results == nil{
                
                realm.add( history.self )
                
            }
            
            //格納先確認
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
        }
    }
    
    
}
