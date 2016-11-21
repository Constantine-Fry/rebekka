//
//  Session.swift
//  Rebekka
//
//  Created by Constantine Fry on 17/05/15.
//  Copyright (c) 2015 Constantine Fry. All rights reserved.
//

import Foundation

public typealias ResourceResultCompletionHandler = ([ResourceItem]?, NSError?) -> Void
public typealias FileURLResultCompletionHandler = (URL?, NSError?) -> Void
public typealias BooleanResultCompletionHandler = (Bool, NSError?) -> Void


/** The FTP session. */
open class Session {
    /** The serial private operation queue. */
    fileprivate let operationQueue: OperationQueue
    
    /** The queue for completion handlers. */
    fileprivate let completionHandlerQueue: OperationQueue
    
    /** The serial queue for streams in operations. */
    fileprivate let streamQueue: DispatchQueue
    
    /** The configuration of the session. */
    fileprivate let configuration: SessionConfiguration
    
    public init(configuration: SessionConfiguration,
        completionHandlerQueue: OperationQueue = OperationQueue.main) {
            self.operationQueue = OperationQueue()
            self.operationQueue.maxConcurrentOperationCount = 1
            self.operationQueue.name = "net.ftp.rebekka.operations.queue"
            self.streamQueue = DispatchQueue(label: "net.ftp.rebekka.cfstream.queue", attributes: [])
            self.completionHandlerQueue = completionHandlerQueue
            self.configuration = configuration
    }
    
    /** Returns content of directory at path. */
    open func list(_ path: String, completionHandler: @escaping ResourceResultCompletionHandler) {
        let operation = ResourceListOperation(configuration: configuration, queue: self.streamQueue)
        operation.completionBlock = {
            [weak operation] in
            if let strongOperation = operation {
                self.completionHandlerQueue.addOperation {
                    completionHandler(strongOperation.resources, strongOperation.error)
                }
            }
        }
        operation.path = path
        if !path.hasSuffix("/") {
            operation.path = operation.path! + "/"
        }
        self.operationQueue.addOperation(operation)
    }
    
    /** Creates new directory at path. */
    open func createDirectory(_ path: String, completionHandler: @escaping BooleanResultCompletionHandler) {
        let operation = DirectoryCreationOperation(configuration: configuration, queue: self.streamQueue)
        operation.completionBlock = {
            [weak operation] in
            if let strongOperation = operation {
                self.completionHandlerQueue.addOperation {
                    completionHandler(strongOperation.error == nil, strongOperation.error)
                }
            }
        }
        operation.path = path
        if !path.hasSuffix("/") {
            operation.path = operation.path! + "/"
        }
        self.operationQueue.addOperation(operation)
    }
    
    /** 
    Downloads file at path from FTP server.
    File is stored in /tmp directory. Caller is responsible for deleting this file. */
    open func download(_ path: String, completionHandler: @escaping FileURLResultCompletionHandler) {
        let operation = FileDownloadOperation(configuration: configuration, queue: self.streamQueue)
        operation.completionBlock = {
            [weak operation] in
            if let strongOperation = operation {
                self.completionHandlerQueue.addOperation {
                    completionHandler(strongOperation.fileURL, strongOperation.error)
                }
            }
        }
        operation.path = path
        self.operationQueue.addOperation(operation)
    }
    
    /** Uploads file from fileURL at path. */
    open func upload(_ fileURL: URL, path: String, completionHandler: @escaping BooleanResultCompletionHandler) {
        let operation = FileUploadOperation(configuration: configuration, queue: self.streamQueue)
        operation.completionBlock = {
            [weak operation] in
            if let strongOperation = operation {
                self.completionHandlerQueue.addOperation {
                    completionHandler(strongOperation.error == nil, strongOperation.error)
                }
            }
        }
        operation.path = path
        operation.fileURL = fileURL
        self.operationQueue.addOperation(operation)
    }
}

public let kFTPAnonymousUser = "anonymous"

/** The session configuration. */
public struct SessionConfiguration {
    /**
    The host of FTP server. Defaults to `localhost`.
    Can be like this: 
        ftp://192.168.0.1
        127.0.0.1:21
        localhost
        ftp.mozilla.org
        ftp://ftp.mozilla.org:21
    */
    public var host: String = "localhost"
    
    /* Whether connection should be passive or not. Defaults to `true`. */
    public var passive = true
    
    /** The encoding of resource names. */
    public var encoding = String.Encoding.utf8
    
    /** The username for authorization. Defaults to `anonymous` */
    public var username = kFTPAnonymousUser
    
    /** The password for authorization. Can be empty. */
    public var password = ""
    
    public init() { }
    
    internal func URL() -> Foundation.URL {
        var stringURL = host
        if !stringURL.hasPrefix("ftp://") {
            stringURL = "ftp://\(host)/"
        }
        let url = Foundation.URL(string: stringURL)
        return url!
    }
}

/** Not secure storage for Servers information. Information is storedin plist file in Cache directory.*/
private class SessionConfigurationStorage {
    
    /** The URL to plist file. */
    fileprivate let storageURL: URL!
    
    init() {
        storageURL = URL(fileURLWithPath: "")
    }
    
    /** Returns an array of all stored servers. */
    fileprivate func allServers() {
        
    }
    
    /** Stores server. */
    fileprivate func storeServer() {
        
    }
    
    /** Deletes server. */
    fileprivate func deleteServer() {
        
    }
    
}

/** Stores credentials in Keychain. */
private class CredentialsStorage {
    
}
