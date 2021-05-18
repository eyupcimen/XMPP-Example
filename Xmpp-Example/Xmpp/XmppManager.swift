//
//  XmppManager.swift
//  Xmpp-Example
//
//  Created by eyup cimen on 19.05.2021.
//

import Foundation
import UIKit
import XMPPFramework

class XMPPClient : NSObject {

    static var xmppClient : XMPPClient?
    static var instance : XMPPClient {
        if(xmppClient == nil) {
            xmppClient = XMPPClient()
        }
        return xmppClient!
    }
    var to = ""
    var grJid = ""
    var myBare = ""
    var password = ""
    var xmppDomain = ""
    var host = ""
    var port : UInt16 = 0
    var stream = XMPPStream()
    var roster: XMPPRoster?
    
    private func connect(userJID jid: String, password pwd: String) {
        guard let uJID = XMPPJID(string: (jid + "@\(xmppDomain)")) else {
            return
        }
        myBare = jid
        password = pwd
        stream.removeDelegate(self)
        stream.addDelegate(self, delegateQueue: DispatchQueue.main)
        stream.hostName = host
        stream.myJID = uJID
        stream.hostPort = port
        stream.startTLSPolicy = .allowed
        do {
            try stream.connect(withTimeout: XMPPStreamTimeoutNone )
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

//MARK: Stream Delegate
extension XMPPClient: XMPPStreamDelegate {
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("Stream Connected")
        do {
            try stream.authenticate(withPassword: password)
        } catch {
            print("Could not authenticate")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("Stream Authenticated")
    }

}
