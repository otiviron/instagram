//
//  ComentsViewController.swift
//  Instagram
//
//  Created by Takahiro Koizumi on 2022/11/29.
//

import UIKit
import Firebase



class ComentsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var comentsTextView: UITextView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    let cellId = "cellId"
    
    var postData: PostData!
    var listener: ListenerRegistration?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        sendButton.isEnabled = false
        comentsTextView.delegate = self
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(ComentsViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ComentsViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //コメントの表示
        var allComents = self.comentsTextView.text!
        
        if postData.coments.isEmpty == true {
            self.comentsTextView.text! = "コメントなし"
            self.comentsTextView.textColor = .gray
            
        }else {
            allComents.removeAll()
            self.comentsTextView.textColor = .black
    
            if postData.coments.count == 1 {
                self.comentsTextView.text! = postData.coments.first!
            }else {
                allComents.removeAll()
                //for文で全要素改行表示
                for i in postData.coments.prefix(postData.coments.count - 1) {
                    allComents += i
                    allComents += "\n"
                    self.comentsTextView.text! = allComents
                }
                let v = postData.coments.last!
                allComents += v
                self.comentsTextView.text! = allComents
            }
        }
        
    }
    
    
    //送信ボタンクリック
    @IBAction func sendButton(_ sender: Any) {
        
        //コメントを更新する
        if let coment = self.textView.text {
            let displayname = Auth.auth().currentUser?.displayName
            let comentData = "\(displayname!) : \(coment)"
            
            //更新データを作成する
            var updateValue: FieldValue
            
            //今回新たに送信を押した場合は、dispkaynameとコメントを追加する更新データを作成
            updateValue = FieldValue.arrayUnion([comentData])
            
            //comentsに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["coments": updateValue])
        }
       
        //コメントの表示
        var allComents = self.comentsTextView.text!
        //allComents.removeAll()
        self.comentsTextView.textColor = .black
        let v = self.textView.text!
        let displayname = Auth.auth().currentUser?.displayName
        let newComents = "\(displayname!) : \(v)"
        allComents += "\n"
        allComents += newComents
        self.comentsTextView.text! = allComents
        
        self.textView.text.removeAll()
        self.viewDidLoad()

        view.endEditing(true)
        
        
    }
    
    //backボタン
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //==============================================================================//==============================================================================
    //keyboard
    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            bottomMargin.constant = keyboardFrameInfo.cgRectValue.height
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification){
        bottomMargin.constant = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        }else {
            sendButton.isEnabled = true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.coments.count
    }
    
//==============================================================================//==============================================================================

    
}
