//
//  ViewController.swift
//  ScreenCastDemoApp
//
//  Created by Sheshnath Kumar on 13/12/18.
//  Copyright © 2018 ProMobi Technologies. All rights reserved.
//

import UIKit
import WebRTC

class ViewController: UIViewController {
    @IBOutlet weak var signalingStatusLabel: UILabel!
    
    let signalClient = SignalClient()
    let webRTCClient = WebRTCClient()
    
    
    
    var signalingConnected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.signalingConnected {
                    self.signalingStatusLabel.text = "Connected"
                    self.signalingStatusLabel.textColor = UIColor.green
                }
                else {
                    self.signalingStatusLabel.text = "Not connected"
                    self.signalingStatusLabel.textColor = UIColor.red
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.signalingConnected = false
        self.signalClient.connect()
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
    }
    
    
    @IBAction func buttonConnectPressed(_ sender: Any) {
        self.webRTCClient.offer { (sdp) in
            //self.hasLocalSdp = true
            self.signalClient.send(sdp: sdp)
        }
    }
    
    @IBAction func buttonRecieveCallPressed(_ sender: Any) {
        self.webRTCClient.answer { (localSdp) in
            //self.hasLocalSdp = true
            self.signalClient.send(sdp: localSdp)
        }
    }
    
    
    @IBAction func showvideoPressed(_ sender: Any) {
        //let vc = VideoViewController(webRTCClient: self.webRTCClient)
        //self.present(vc, animated: true, completion: nil)
        self.webRTCClient.startCaptureLocalVideo()
    }
    
    
}




extension ViewController: SignalClientDelegate {
    func signalClientDidConnect(_ signalClient: SignalClient) {
        self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalClient) {
        self.signalingConnected = false
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

extension ViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        //self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate)
        
    }
}
