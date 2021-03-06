//
//  MultipeerConnectivity.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ sucsess: Bool, _ error: Error?) -> ())?)
    weak var delegate : ICommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol ICommunicatorDelegate : class {
    
    var communicator: ICommunicator {get set} //!!!
    
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func userDidBecome(userID: String, online:Bool)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
//    func getConversation(key: Int) -> ConversationElement
    
}

class MultipeerCommunicator:NSObject, ICommunicator {
    
    private var sessions = [ String : MCSession ]()
    
    private let peerID = MCPeerID(displayName: UIDevice.current.identifierForVendor?.uuidString ?? "volodin")
    private var browser: MCNearbyServiceBrowser!
    private var advertiser: MCNearbyServiceAdvertiser!
    
    private let serviceType = "tinkoff-chat"
    private let discoveryInfo = ["userName" : "mac"]
    private let messageEvent = "TextMessage"
    
    weak var delegate: ICommunicatorDelegate?
    var online: Bool = true
    
    override init() {
        super.init()
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func createSession(forUser userID: String) -> MCSession {
        if let session = sessions[userID] {
            return session
        } else {
            
            let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
            sessions[userID] = session
            session.delegate = self
            
            return session
        }
    }
    
    // MARK: communicator
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        guard let session = sessions[userID] else {
            return
        }
        guard let message = createMessage(withText: string) else {
            return
        }
        
        for peer in session.connectedPeers {
            if peer != peerID {
                do {
                    try session.send(message, toPeers: [peer], with: .reliable)
                    completionHandler?(true, nil)
                } catch {
                }
            }
        }
        
        delegate?.didReceiveMessage(text: string, fromUser: UIDevice.current.identifierForVendor?.uuidString ?? "volodin", toUser: userID) //!!!
    }
    
    func createMessage(withText text: String) -> Data? {
        guard let messageId = generateMessageId() else {
            return nil
        }
        
        let messageJson = [
            "eventType" : messageEvent,
            "messageId" : messageId,
            "text"      : text
        ]
        
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageJson, options: [])
            return messageData
        } catch {
            print("Error creating message json: \(error.localizedDescription)")
            return nil
        }
    }
    
    func generateMessageId() -> String? {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string
    }
}

// MARK: Session delegate
extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        do {
            guard let messageJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [ String : String ] else {
                print("Error parsing message json: eventType != \(messageEvent)")
                return
            }
            guard messageJson["eventType"] == messageEvent else { return }
            guard let messageText = messageJson["text"] else {
                print("Error parsing message json: no text")
                return
            }
            print("%@", messageJson)
            delegate?.didReceiveMessage(text: messageText, fromUser: peerID.displayName, toUser: UIDevice.current.identifierForVendor?.uuidString ?? "volodin")
        } catch {
            print("Error parsing message json: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case .connected:
//            delegate?.userDidBecome(userID: peerID.displayName, online: true)
            break
            
        case .connecting:
            break
            
        case .notConnected:
//            delegate?.userDidBecome(userID: peerID.displayName, online: false)
            break
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

// MARK: MCNearbyServiceBrowserDelegate
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate  {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("%@", "lostPeer: \(peerID)")
        
        sessions[peerID.displayName] = nil
        delegate?.didLostUser(userID: peerID.displayName)
        delegate?.userDidBecome(userID: peerID.displayName, online: false)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        
        let session = createSession(forUser: peerID.displayName)
        
        if !session.connectedPeers.contains(peerID) {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
            let userName = info?["userName"] ?? "Noname"
            delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
            delegate?.userDidBecome(userID: peerID.displayName, online: true)
        }
//        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

// MARK: MCNearbyServiceAdvertiserDelegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        let session = createSession(forUser: peerID.displayName)
        
        
            if !session.connectedPeers.contains(peerID) {
                invitationHandler(true, session)
            } else {
                invitationHandler(false, nil)
            }
        
    }
}
