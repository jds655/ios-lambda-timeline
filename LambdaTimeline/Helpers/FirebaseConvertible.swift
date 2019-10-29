//
//  FirebaseConvertible.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

//TODO: - WHat is this?
protocol FirebaseConvertible {
    var dictionaryRepresentation: [String: Any] { get }
}
