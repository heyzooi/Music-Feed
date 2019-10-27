//
//  Cache.swift
//  Music Feed
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//  Copyright © 2019 HZ Apps. All rights reserved.
//

import Foundation

class Cache {

    static let shared = Cache()

    let images = NSCache<NSURL, NSData>()

}
