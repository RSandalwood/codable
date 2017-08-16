//
//  MessagesViewController.swift
//  codable
//
//  Created by Patrick McCarron on 8/14/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    
    var apiManager : OraAPIManager?
    var messages = [OraObject]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillShow, object:nil, queue:nil) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                  let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
                  let bottomOffset = self?.view.safeAreaInsets.bottom
                else { return }
            
            self?.bottomConstraint.constant = bottomOffset - keyboardInfo.height
            
            UIView.animate(withDuration: duration.doubleValue) {
                self?.view.layoutIfNeeded()
            }
        }

        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillHide, object:nil, queue:nil) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
                else { return }
            
            self?.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: duration.doubleValue) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let apiManager = apiManager {
            apiManager.requestMessages(completion: { [weak self] response in
                print(response)
                self?.messages = response.data
            })
        }
    }
    
    @IBAction func submitMessage() {
        print("Message: \(String(describing: messageField.text))")
        messageField.resignFirstResponder()
    }
}

extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitMessage()
        return true
    }
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") else { return UITableViewCell() }
        cell.contentView.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows = \(messages.count)")
        return messages.count
    }
}

