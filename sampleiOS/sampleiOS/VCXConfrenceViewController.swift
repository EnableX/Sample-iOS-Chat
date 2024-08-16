//
//  VCXConfrenceViewController.swift
//  sampleTextApp
//
//  Created by Hemraj on 16/11/18.
//  Copyright © 2018 VideoChat. All rights reserved.
//

import UIKit
import EnxRTCiOS
import SVProgressHUD
import AMBubbleTableViewController
class VCXConfrenceViewController: AMBubbleTableViewController {
    @IBOutlet weak var sendLogBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    var roomInfo : VCXRoomInfoModel!
    var param : [String : Any] = [:]
    var remoteRoom : EnxRoom!
    var objectJoin : EnxRtc!
    var chatArray : NSMutableArray! = []
    var connectedUserArray : [EnxUserList] = []
    var tempHeight : CGFloat!
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        self.dataSource = self as AMBubbleTableDataSource
        self.delegate = self as AMBubbleTableDelegate
        self.setTableStyle(AMBubbleTableStyleFlat)
        let optionDict = [AMOptionsBubblePressEnabled:false,AMOptionsBubbleSwipeEnabled:false,AMOptionsButtonTextColor:UIColor.red,AMOptionsTimestampHeight:0,AMOptionsAccessoryMargin:20] as [String : Any]
        self.setBubbleTableOptions(optionDict)
        
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = UIColor.clear
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Adding Pan Gesture for localPlayerView
        objectJoin = EnxRtc()
        self.createToken()
        self.navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.HideKey), name: NSNotification.Name(rawValue: "HideKeyBoard"), object: nil)
        self.view.bringSubviewToFront(topView)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    @objc func HideKey()  {
        self.textView.resignFirstResponder()
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyBoardHeight = keyboardSize.height
            tempHeight = keyBoardHeight
            print(keyBoardHeight)
            UIView.animate(withDuration: 0.25, animations: {
                if(self.view.frame.origin.y == 0.0){
                    self.view.frame.origin.y -= keyBoardHeight
                    self.tableView.frame.origin.y += keyBoardHeight
                    self.tableView.frame.size.height -= keyBoardHeight
                    self.resizetheChat()
                }
                
            })
        }
    }
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.25, animations: {
            if(self.view.frame.origin.y < 0){
                self.view.frame.origin.y = 0
                self.tableView.frame.origin.y = 0
                self.tableView.frame.size.height = self.view.frame.size.height
                self.resizetheChat()
            }
        })
    }
    
    private func resizetheChat(){
        if(chatArray.count > 1){
            let index = IndexPath(row: chatArray.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.leaveRoom()
    }
    // MARK: - sendLogtoServerEvent
    /**
     input parameter - Any
     Return  - Nil
     This method will Save all Socket Event logs to server
     **/
    @IBAction func sendLogtoServerEvent(_ sender: Any) {
        guard remoteRoom != nil else {
            return
        }
        remoteRoom.postClientLogs()
        print("Send Logs")
    }
    
    // MARK: - createTokrn
    /**
     input parameter - Nil
     Return  - Nil
     This method will initiate the Room for stream
     **/
    private func createToken(){
        guard VCXNetworkManager.isReachable() else {
            EnxToastView.showInParent(parentView: self.view, withText: "Kindly check your Network Connection", forDuration: 1.0)
            return
        }
        let inputParam : [String : String] = ["name" :roomInfo.participantName , "role" :  roomInfo.role ,"roomId" : roomInfo.room_id, "user_ref" : "2236"]
        SVProgressHUD.show()
        VCXServicesClass.featchToken(requestParam: inputParam, completion:{tokenInfo  in
            DispatchQueue.main.async {
              //  Success Response from server
                if let token = tokenInfo.token {
                    let videoSize : [String : Any] =  ["minWidth" : 320 , "minHeight" : 180 , "maxWidth" : 1280, "maxHeight" :720]
                    let localStreamInfo : [String : Any] = ["video" : self.param["video"]! ,"audio" : self.param["audio"]! ,"data" :self.param["chat"]! ,"name" :self.roomInfo.participantName!,"type" : "public", "chat_only" : true ,"maxVideoBW" : 120 ,"minVideoBW" : 80 , "videoSize" : videoSize]
                    let roomInfoparam = ["allow_reconnect" : true , "number_of_attempts" : 3,"timeout_interval" : 20] as [String : Any]
                    
                    let Stream = self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: localStreamInfo, roomInfo: roomInfoparam, advanceOptions: nil)
                }
                //Handel if Room is full
                else if (tokenInfo.token == nil && tokenInfo.error == nil){
                    EnxToastView.showInParent(parentView: self.view, withText:"Token Denied. Room is full", forDuration: 1.0)
                    self.navigationController?.popViewController(animated: true)
                }
                //Handeling server error
                else{
                    print(tokenInfo.error!)
                    EnxToastView.showInParent(parentView: self.view, withText: tokenInfo.error!, forDuration: 1.0)
                    self.navigationController?.popViewController(animated: true)
                }
                SVProgressHUD.dismiss()
            }
        })
        
    }
    /**
     Input parameter : - Nil
     OutPut : - Nil
     Its method will exist from Room
     **/
    private func leaveRoom(){
        UIApplication.shared.isIdleTimerDisabled = false
        remoteRoom?.disconnect()
        
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
/*
 // MARK: - Extension
 Delegates Methods
 */
extension VCXConfrenceViewController : EnxRoomDelegate, EnxStreamDelegate {
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
        //todo
    }
    
    //Mark - EnxRoom Delegates
    /*
     This Delegate will notify to User Once he got succes full join Room
     */
    func room(_ room: EnxRoom?, didConnect roomMetadata: [String : Any]?) {
        remoteRoom = room
        EnxToastView.showInParent(parentView: self.view, withText: "Room Connection succesful", forDuration: 1.0)
        guard roomMetadata?["userList"] as? [Any] != nil else{
            return
        }
        guard let item  = roomMetadata?["userList"] as? [Any] else {
            return
        }
        for subIteam in item {
            let userList = EnxUserList()
            userList.client_Id = ((subIteam as! [String : Any])["clientId"]! as! String)
            userList.name = ((subIteam as! [String : Any])["name"]! as! String)
            connectedUserArray.append(userList)
        }
    }
    /*
     This Delegate will notify to User Once he Getting error in joining room
     */
    func room(_ room: EnxRoom?, didError reason: [Any]?) {
        guard let tempDict = reason?[0] as? [String : Any], reason!.count>0 else {
            return
        }
        EnxToastView.showInParent(parentView: self.view, withText: tempDict["msg"] as! String, forDuration: 1.0)
    }
    /*
     This Delegate will notify once new user join
     */
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
        let item = Data![0]
        let enxuser = EnxUserList();
        enxuser.client_Id = ((item as! [String : Any])["clientId"]! as! String)
        enxuser.name = ((item as! [String : Any])["name"]! as! String)
        connectedUserArray.append(enxuser)
        
    }
    /*
     This Delegate will notify if any user leave room
     */
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        let item = Data![0]
        for (index , userList) in connectedUserArray.enumerated(){
            if(userList.client_Id == ((item as! [String : Any])["clientId"]! as! String)){
                connectedUserArray.remove(at: index)
                return
            }
        }
    }
    /*
     This Delegate will notify to User if Room Got discunnected
     */
    func didRoomDisconnect(_ response: [Any]?) {
       self.navigationController?.popViewController(animated: true)
    }
    /*
     This Delegate will notify to User if any new User Reconnect the room
     */
    func room(_ room: EnxRoom?, didReconnect reason: String?) {
        //To Do
    }
    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        let resDict = reason![0] as! [String : Any]
        EnxToastView.showInParent(parentView: self.view, withText: resDict["msg"] as! String, forDuration: 1.0)
    }
    /**
        Recive Chat data at room label
     **/
    func room(_ room: EnxRoom, didMessageReceived data: [Any]?) {
        guard let msgDict : [String : Any] = data?[0] as? [String : Any]   else {
            return
        }
        var name = "Unknown"
        for item  in connectedUserArray {
            if(item.client_Id == (msgDict["senderId"] as! String)){
                name = item.name
                break
            }
        }
        let sampleDict = ["text": msgDict["message"] as! String,
                          "date":NSDate(),
                          "type":AMBubbleCellReceived,
                          "color":UIColor.blue,
                          "username": name
            ] as [String : Any]
        chatArray.add(sampleDict)
        let index = IndexPath(row: chatArray.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [index], with: .right)
        tableView.endUpdates()
        tableView.scrollToRow(at: index, at: .bottom, animated: true)

    }
    /**
       Recive Custome data at room label
    **/
    func room(_ room: EnxRoom, didUserDataReceived data: [Any]?) {
        //To Do
    }
    /*
     This Delegate will notify when internet connection lost.
     */
    func room(_ room: EnxRoom?, didConnectionLost data: [Any]?) {
        
    }
    
    /*
     This Delegate will notify on connection interuption example switching from Wifi to 4g.
     */
    func room(_ room: EnxRoom?, didConnectionInterrupted data: [Any]?) {
        
    }
    
    /*
     This Delegate will notify reconnect success.
     */
    func room(_ room: EnxRoom?, didUserReconnectSuccess data: [String : Any]?) {
        
    }
    
}
extension VCXConfrenceViewController: AMBubbleTableDelegate,AMBubbleTableDataSource{
    func didSendText(_ text: String!) {
        guard remoteRoom != nil else {
            return
        }
        remoteRoom.sendMessage(text, isBroadCast: true, recipientIDs: [])
        let dict :[String : Any] = ["text": text!,
                    "date": NSDate(),
                    "type": AMBubbleCellSent,
                    "username": "Me:"] as [String : Any]
        chatArray .add(dict)
        let index = IndexPath(row: chatArray.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [index], with: .right)
        tableView.endUpdates()
        tableView.scrollToRow(at: index, at: .bottom, animated: true)
    }
    
    func numberOfRows() -> Int {
        return chatArray.count
    }
    
    func cellTypeForRow(at indexPath: IndexPath!) -> AMBubbleCellType {
        let dict  = chatArray?[indexPath.row] as! [String : Any]
        return dict["type"] as! AMBubbleCellType
    }
    
    func textForRow(at indexPath: IndexPath!) -> String! {
        let dict  = chatArray?[indexPath.row] as! [String : Any]
        return dict["text"] as? String
    }
    
    func timestampForRow(at indexPath: IndexPath!) -> Date! {
        return NSDate() as Date
    }
    
    func avatarForRow(at indexPath: IndexPath!) -> UIImage! {
        return UIImage.init(named: "user")
    }
    func usernameForRow(at indexPath: IndexPath!) -> String! {
        let dict  = chatArray?[indexPath.row] as! [String : Any]
        return dict["username"] as? String
    }
    func swipedCell(at indexPath: IndexPath!, withFrame frame: CGRect, andDirection direction: UISwipeGestureRecognizer.Direction) {
        print("Direction");
    }
    
}
