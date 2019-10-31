//
//  Comment.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import FirebaseAuth

class Comment: FirebaseConvertible, Equatable {
    
    static private let textKey = "text"
    static private let author = "author"
    static private let timestampKey = "timestamp"
    static private let mediaURLKey = "mediaurl"
    static private let mediaTypeKey = "mediaType"
    
    let text: String?
    let author: Author
    let timestamp: Date
    let mediaURL: URL?
    
    init(text: String?, author: Author, timestamp: Date = Date(), mediaURL: URL?) {
        self.text = text
        self.author = author
        self.timestamp = timestamp
        self.mediaURL = mediaURL
    }
    
    init?(dictionary: [String : Any]) {
        guard let text = dictionary[Comment.textKey] as? String,
            let authorDictionary = dictionary[Comment.author] as? [String: Any],
            let author = Author(dictionary: authorDictionary),
            let timestampTimeInterval = dictionary[Comment.timestampKey] as? TimeInterval,
            let mediaURL = dictionary[Comment.mediaURLKey] as? String else { return nil }
        
        self.text = text != "nil" ? text : nil
        self.author = author
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        self.mediaURL = mediaURL != "nil" ? URL(string: mediaURL) : nil
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [Comment.textKey: text ?? "nil",
                Comment.author: author.dictionaryRepresentation,
                Comment.timestampKey: timestamp.timeIntervalSince1970,
                Comment.mediaURLKey: mediaURL?.absoluteString ?? "nil"
        ]
    }
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.author == rhs.author &&
            lhs.timestamp == rhs.timestamp
    }
}
