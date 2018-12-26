//
//  PeerManager.swift
//  ScreenCast
//
//  Created by Sheshnath Kumar on 26/12/18.
//  Copyright © 2018 ProMobi Technologies. All rights reserved.
//

import UIKit
import WebRTC

class PeerManager: NSObject {

    static let shared = PeerManager()
    let signalClient = SignalClient()
    let webRTCClient = WebRTCClient()
    
    func requestForConnectWithPeer() -> Void {
        
        self.signalClient.connect()
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        
        self.webRTCClient.offer { (sdp) in
            //self.hasLocalSdp = true
            self.signalClient.send(sdp: sdp)
        }
    }
    
    func answerPeerRequestForConnect() -> Void {
        self.webRTCClient.answer { (localSdp) in
            //self.hasLocalSdp = true
            self.signalClient.send(sdp: localSdp)
        }
    }
    
    func push(videoFrame: RTCVideoFrame) {
        self.webRTCClient.push(videoFrame: videoFrame)
    }
}



extension PeerManager: SignalClientDelegate {
    func signalClientDidConnect(_ signalClient: SignalClient) {
        //self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalClient) {
        //self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            //self.hasRemoteSdp = true
        }
    }
    
    func signalClient(_ signalClient: SignalClient, didReceiveCandidate candidate: RTCIceCandidate) {
        print("Received remote candidate")
        //self.remoteCandidateCount += 1
        self.webRTCClient.set(remoteCandidate: candidate)
    }
}

extension PeerManager: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        //self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate)
        
    }
}

