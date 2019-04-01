
//
//  PlayeCell.swift
//  mpdemo
//
//  Created by USER on 2018/11/14.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class PlayeCell: UITableViewCell {


    lazy var containerView: UIImageView = {
        let containerView = UIImageView()
        containerView.isUserInteractionEnabled = true

        return containerView
    }()
    
    lazy var playBtn: UIButton = {
        let playBtn = UIButton(type: .custom)
        playBtn.setTitle("播放", for: .normal)
        playBtn.setTitleColor(UIColor.black, for: .normal)
        playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        return playBtn
    }()
    
    var playBtnCallBack: ((PlayeCell?, IndexPath?)->())?
    
    var indexPath : IndexPath?

    @objc func playBtnAction(_ sender: UIButton) {
        if let callBack = playBtnCallBack {
            callBack(self, indexPath)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(playBtn)
        
        containerView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(contentView)
        }
        
        playBtn.snp.makeConstraints { (make) in
            make.center.equalTo(containerView)
            make.width.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
