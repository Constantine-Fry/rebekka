//
//  ReadStreamOperation.swift
//  Rebekka
//
//  Created by Constantine Fry on 25/05/15.
//  Copyright (c) 2015 Constantine Fry. All rights reserved.
//

import Foundation

/** The base class for read stream operations. */
internal class ReadStreamOperation: StreamOperation {
    
    internal lazy var temporaryBuffer: UnsafeMutablePointer<UInt8> = {
        return UnsafeMutablePointer<UInt8>.allocate(capacity: 65536)
    }()
    
    lazy var readStream: InputStream = {
        let cfStream = CFReadStreamCreateWithFTPURL(nil, self.fullURL() as CFURL)
        CFReadStreamSetDispatchQueue(cfStream.takeUnretainedValue(), self.queue)
        return cfStream.takeRetainedValue()
    }()
    
    override func start() {
        self.startOperationWithStream(self.readStream)
    }
}

