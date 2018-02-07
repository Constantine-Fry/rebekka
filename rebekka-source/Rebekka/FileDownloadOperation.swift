//
//  FileDownloadOperation.swift
//  Rebekka
//
//  Created by Constantine Fry on 25/05/15.
//  Copyright (c) 2015 Constantine Fry. All rights reserved.
//

import Foundation

/** Operation for downloading a file from FTP server. */
internal class FileDownloadOperation: ReadStreamOperation {
    
    private var fileHandle: FileHandle?
    var fileURL: URL?
    var progressHandler: DownloadProgressHandler?
    
    override func start() {
        let filePath = (NSTemporaryDirectory() as NSString).appendingPathComponent(path ?? UUID().uuidString)
        self.fileURL = URL(fileURLWithPath: filePath)
        do {
            try Data().write(to: self.fileURL!, options: NSData.WritingOptions.atomic)
            fileHandle = try FileHandle(forWritingTo: self.fileURL!)
            startOperationWithStream(self.readStream)
        } catch let error as NSError {
            self.error = error
            finishOperation()
        }
    }
    
    override func streamEventEnd(_ aStream: Stream) -> (Bool, NSError?) {
        fileHandle?.closeFile()
        return (true, nil)
    }
    
    override func streamEventError(_ aStream: Stream) {
        super.streamEventError(aStream)
        fileHandle?.closeFile()
        if let fileURL = self.fileURL {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch _ {
            }
        }
        self.fileURL = nil
    } 
    
    override func streamEventHasBytes(_ aStream: Stream) -> (Bool, NSError?) {
        guard let totalBytesSize = aStream.property(forKey: Stream.PropertyKey(rawValue: kCFStreamPropertyFTPResourceSize as String)) as? Int,
            let inputStream = aStream as? InputStream else {
                return (true, nil)
        }
        var downloadedBytes: Int = 0
        var parsetBytes: Int = 0
        repeat {
            parsetBytes = inputStream.read(self.temporaryBuffer, maxLength: 65536)
            downloadedBytes += parsetBytes
            progressHandler?(Float(downloadedBytes) / Float(totalBytesSize))
            if parsetBytes > 0 {
                autoreleasepool {
                    let data = Data(bytes: UnsafePointer<UInt8>(self.temporaryBuffer), count: parsetBytes)
                    self.fileHandle!.write(data)
                }
            }
        } while (parsetBytes > 0)
        return (true, nil)
    }
}
