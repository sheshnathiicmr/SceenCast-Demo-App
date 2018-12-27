//
//  SampleHandler.swift
//  BroadcastUpload
//
//  Created by Sheshnath Kumar on 24/12/18.
//  Copyright © 2018 Demo Technologies. All rights reserved.
//

import ReplayKit
import WebRTC

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        PeerManager.shared.requestForConnectWithPeer()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
            case RPSampleBufferType.video:
                // Handle video sample buffer
                guard let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    break
                }
                let width = CVPixelBufferGetWidth(imageBuffer)
                let height = CVPixelBufferGetHeight(imageBuffer)
                
                //let pixelFormat = CVPixelBufferGetPixelFormatType(imageBuffer) // kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
                let timeStampNs: Int64 = Int64(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000000000)
                let rtcPixlBuffer = RTCCVPixelBuffer(pixelBuffer: imageBuffer)
                let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixlBuffer, rotation: ._0, timeStampNs: timeStampNs)
                //PeerManager.shared.webRTCClient.setVideoFormat(width: Int32(width), height: Int32(height), fps: Int32(15))
                PeerManager.shared.push(videoFrame: rtcVideoFrame)
                break
            case RPSampleBufferType.audioApp:
                // Handle audio sample buffer for app audio
                break
            case RPSampleBufferType.audioMic:
                // Handle audio sample buffer for mic audio
                break
        }
    }
    
    
}
