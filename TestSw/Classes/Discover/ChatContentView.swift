//
//  ChatContentView.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/18.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

private let kChatContentCell = "kChatContentCell"

class ChatContentView: UIView, NibLoadable {

    @IBOutlet weak var tableview: UITableView!
    fileprivate lazy var messages : [NSAttributedString] = [NSAttributedString]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableview.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kChatContentCell)
        tableview.backgroundColor = UIColor.clear
        tableview.separatorStyle = .none
        
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableViewAutomaticDimension
    }
    
    func insertMsg(_ message : NSAttributedString) {
        messages.append(message)
        tableview.reloadData()
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatContentView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentCell, for: indexPath) as! ChatContentCell
        cell.contentLabel.attributedText = messages[indexPath.row]
        return cell
    }
}
