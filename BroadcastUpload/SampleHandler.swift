//
//  SampleHandler.swift
//  BroadcastUpload
//
//  Created by Sheshnath Kumar on 24/12/18.
//  Copyright © 2018 ProMobi Technologies. All rights reserved.
//

import ReplayKit
import WebRTC

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional. 
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
                
                /*let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
                CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))
                let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
                let height = CVPixelBufferGetHeight(imageBuffer!)
                let src_buff = CVPixelBufferGetBaseAddress(imageBuffer!)
                let data = NSData(bytes: src_buff, length: bytesPerRow * height)
                CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags(rawValue: 0))*/
                
                // Handle video sample buffer
                guard let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    break
                }
                let pixelFormat = CVPixelBufferGetPixelFormatType(imageBuffer) // kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
                let timeStampNs: Int64 = Int64(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000000000)
                let rtcPixlBuffer = RTCCVPixelBuffer(pixelBuffer: imageBuffer)
                let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixlBuffer, rotation: ._0, timeStampNs: timeStampNs)
                
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
