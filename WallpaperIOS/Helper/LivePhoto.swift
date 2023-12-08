//
//  LivePhotoViet.swift
//  Live Photos Sample
//
//  Created by MAC on 04/12/2023.
//  Copyright © 2023 Limit Point LLC. All rights reserved.
//

import SwiftUI
import AVFoundation
import MobileCoreServices
import Photos

actor LivePhoto {
    static let sharedInstance = LivePhoto()
    
    func assemble(photoURL: URL, videoURL: URL, progress: ((Float) -> Void)? = nil) async throws -> ((URL, URL)) {
        let cacheDirectory = cachesDirectory()
        print("DEBUG: \(cacheDirectory)")
        print("DEBUG: \(photoURL)")
        print("DEBUG: \(videoURL)")
        let identifier = UUID().uuidString

        let pairedPhotoURL = addIdentifier(
            identifier,
            fromPhotoURL: photoURL,
            to: cacheDirectory.appendingPathComponent(identifier).appendingPathExtension("jpg"))

        let pairedVideoURL =  await addIdentifier(
            identifier,
            fromVideoURL: videoURL,
            to: cacheDirectory.appendingPathComponent(identifier).appendingPathExtension("mov"),
            progress: progress)

        
        return ((pairedPhotoURL, pairedVideoURL))
    }
    
    // MARK: - Metadata for Photo
    private func addIdentifier(
        _ identifier: String,
        fromPhotoURL photoURL: URL,
        to destinationURL: URL
    ) -> URL {
              // 1
        guard let imageSource = CGImageSourceCreateWithURL(photoURL as CFURL, nil),
              // 2
              let imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
              // 3
              var imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable : Any] else {
            print("DEBUG: aa")
            return URL(string: "")!
        }
        // 4
        let identifierInfo = ["17" : identifier]
        imageProperties[kCGImagePropertyMakerAppleDictionary] = identifierInfo
        // 5
        guard let imageDestination = CGImageDestinationCreateWithURL(destinationURL as CFURL, UTType.jpeg.identifier as CFString, 1, nil) else {
            print("DEBUG: bb")
            return URL(string: "")!
        }
        // 6
        CGImageDestinationAddImage(imageDestination, imageRef, imageProperties as CFDictionary)
        // 7
        if CGImageDestinationFinalize(imageDestination) {
            return destinationURL
        } else {
            print("DEBUG: cc")
            return URL(string: "")!
        }
    }

    // MARK: - Metadata for video
    private func metadataItem(for identifier: String) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.keySpace = AVMetadataKeySpace.quickTimeMetadata // "mdta"
        item.dataType = "com.apple.metadata.datatype.UTF-8"
        item.key = AVMetadataKey.quickTimeMetadataKeyContentIdentifier as any NSCopying & NSObjectProtocol // "com.apple.quicktime.content.identifier"
        item.value = identifier as any NSCopying & NSObjectProtocol
        return item
    }

    // MARK: - Create a Timed Metadata Track of still images:
    private func stillImageTimeMetadataAdaptor() -> AVAssetWriterInputMetadataAdaptor {
        let quickTimeMetadataKeySpace = AVMetadataKeySpace.quickTimeMetadata.rawValue // "mdta"
        let stillImageTimeKey = "com.apple.quicktime.still-image-time"
        let spec: [NSString : Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as NSString : "\(quickTimeMetadataKeySpace)/\(stillImageTimeKey)",
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as NSString : kCMMetadataBaseDataType_SInt8]
        var desc : CMFormatDescription? = nil
        CMMetadataFormatDescriptionCreateWithMetadataSpecifications(
            allocator: kCFAllocatorDefault,
            metadataType: kCMMetadataFormatType_Boxed,
            metadataSpecifications: [spec] as CFArray,
            formatDescriptionOut: &desc)
        let input = AVAssetWriterInput(
            mediaType: .metadata,
            outputSettings: nil,
            sourceFormatHint: desc)
        return AVAssetWriterInputMetadataAdaptor(assetWriterInput: input)
    }

    // MARK: - Create Timed Metadata Track Metadata for still images
    private func stillImageTimeMetadataItem() -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.key = "com.apple.quicktime.still-image-time" as any NSCopying & NSObjectProtocol
        item.keySpace = AVMetadataKeySpace.quickTimeMetadata // "mdta"
        item.value = 0 as any NSCopying & NSObjectProtocol
        item.dataType = kCMMetadataBaseDataType_SInt8 as String // "com.apple.metadata.datatype.int8"
        return item
    }

    private func addIdentifier(
        _ identifier: String,
        fromVideoURL videoURL: URL,
        to destinationURL: URL,
        progress: ((Float) -> Void)? = nil
    ) async -> URL {
        let asset = AVURLAsset(url: videoURL)
        
        // --- Reader ---
        
        // Create the video reader
        let videoReader = try! AVAssetReader(asset: asset)
        
        // Create the video reader output
        guard let videoTrack = try! await asset.loadTracks(withMediaType: .video).first else {
            print("DEBUG: dd")
            return URL(string: "")!
        }
        let videoReaderOutputSettings : [String : Any] = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderOutputSettings)
        
        // Add the video reader output to video reader
        videoReader.add(videoReaderOutput)
        
        // Create the audio reader
        let audioReader = try! AVAssetReader(asset: asset)
        
        // Create the audio reader output
//        guard let audioTrack = try! await asset.loadTracks(withMediaType: .audio).first else {
//            print("DEBUG: ee")
//            return URL(string: "")!
//        }
//        let audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
//
//        // Add the audio reader output to audioReader
//        audioReader.add(audioReaderOutput)
        
        // --- Writer ---
        
        // Create the asset writer
        let assetWriter = try! AVAssetWriter(outputURL: destinationURL, fileType: .mov)
        
        // Create the video writer input
        let videoWriterInputOutputSettings : [String : Any] = [
            AVVideoCodecKey : AVVideoCodecType.h264,
            AVVideoWidthKey : try! await videoTrack.load(.naturalSize).width,
            AVVideoHeightKey : try! await videoTrack.load(.naturalSize).height]
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoWriterInputOutputSettings)
        videoWriterInput.transform = try! await videoTrack.load(.preferredTransform)
        videoWriterInput.expectsMediaDataInRealTime = true
        
        // Add the video writer input to asset writer
        assetWriter.add(videoWriterInput)
        
        // Create the audio writer input
//        let audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
//        audioWriterInput.expectsMediaDataInRealTime = false
        
        // Add the audio writer input to asset writer
//        assetWriter.add(audioWriterInput)
        
        let identifierMetadata = metadataItem(for: identifier)
        // Create still image time metadata track
        let stillImageTimeMetadataAdaptor = stillImageTimeMetadataAdaptor()
        assetWriter.metadata = [identifierMetadata]
        assetWriter.add(stillImageTimeMetadataAdaptor.assetWriterInput)
      
        // Start the asset writer
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: CMTime.zero)

        let frameCount = try! await asset.frameCount()
        let stillImagePercent: Float = 0.5
            await stillImageTimeMetadataAdaptor.append(
                AVTimedMetadataGroup(
                    items: [stillImageTimeMetadataItem()],
                    timeRange: try! asset.makeStillImageTimeRange(percent: stillImagePercent, inFrameCount: frameCount))
            )

        async let writingVideoFinished: Bool = withCheckedThrowingContinuation { continuation in
                Task {
                    videoReader.startReading()
                    var currentFrameCount = 0
                    videoWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "videoWriterInputQueue")) {
                        while videoWriterInput.isReadyForMoreMediaData {
                            if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer()  {
                                currentFrameCount += 1
                                if let progress {
                                    let progressValue = min(Float(currentFrameCount)/Float(frameCount), 1.0)
                                    Task { @MainActor in
                                        progress(progressValue)
                                    }
                                }
                                if !videoWriterInput.append(sampleBuffer) {
                                    videoReader.cancelReading()
                                    return
                                }
                            } else {
                                videoWriterInput.markAsFinished()
                                continuation.resume(returning: true)
                                return
                            }
                        }
                    }
                }
            }
            
//            async let writingAudioFinished: Bool = withCheckedThrowingContinuation { continuation in
//                Task {
//                    audioReader.startReading()
//                    audioWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "audioWriterInputQueue")) {
//                        while audioWriterInput.isReadyForMoreMediaData {
//                            if let sampleBuffer = audioReaderOutput.copyNextSampleBuffer() {
//                                if !audioWriterInput.append(sampleBuffer) {
//                                    audioReader.cancelReading()
//                                    return
//                                }
//                            } else {
//                                audioWriterInput.markAsFinished()
//                                continuation.resume(returning: true)
//                                return
//                            }
//                        }
//                    }
//                }
//            }
          
            await (_) = try! (writingVideoFinished) /* (writingVideoFinished, writingAudioFinished)*/

        await assetWriter.finishWriting()
           return destinationURL
    }


    

}

extension LivePhoto {
    
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    
    
}

extension AVAsset {
    func frameCount(exact: Bool = false) async throws -> Int {
         let videoReader = try AVAssetReader(asset: self)
         guard let videoTrack = try await self.loadTracks(withMediaType: .video).first else { return 0 }
         if !exact {
             async let duration = CMTimeGetSeconds(self.load(.duration))
             async let nominalFrameRate = Float64(videoTrack.load(.nominalFrameRate))
             return try await Int(duration * nominalFrameRate)
         }
         let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
         videoReader.add(videoReaderOutput)
         videoReader.startReading()
         var frameCount = 0
         while let _ = videoReaderOutput.copyNextSampleBuffer() {
             frameCount += 1
         }
         videoReader.cancelReading()
         return frameCount
     }

     func makeStillImageTimeRange(percent: Float, inFrameCount: Int = 0) async throws -> CMTimeRange {
         var time = try await self.load(.duration)
         var frameCount = inFrameCount
         if frameCount == 0 {
             frameCount = try await self.frameCount(exact: true)
         }
         let duration = Int64(Float(time.value) / Float(frameCount))
         time.value = Int64(Float(time.value) * percent)
         return CMTimeRangeMake(start: time, duration: CMTimeMake(value: duration, timescale: time.timescale))
     }


}
