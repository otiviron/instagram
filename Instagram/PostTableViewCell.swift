//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Takahiro Koizumi on 2022/11/26.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var comentsButton: UIButton!
    @IBOutlet weak var comentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        //画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        //コメントの表示
        var allComents = self.comentsLabel.text!
        
        if postData.coments.isEmpty == true {
            self.comentsLabel.text! = "コメントなし"
            self.comentsLabel.textColor = .gray
            
        }else {
            allComents.removeAll()
            self.comentsLabel.textColor = .black
    
            if postData.coments.count == 1 {
                self.comentsLabel.text! = postData.coments.first!
            }else {
                allComents.removeAll()
                //for文で全要素改行表示
                for i in postData.coments.prefix(postData.coments.count - 1) {
                    allComents += i
                    allComents += "\n"
                    self.comentsLabel.text! = allComents
                }
                let v = postData.coments.last!
                allComents += v
                self.comentsLabel.text! = allComents
            }
        }
           
    }
    
}
