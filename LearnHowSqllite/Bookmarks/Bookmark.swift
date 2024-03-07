//
//  File.swift
//  Lander Torah
//
//  Created by Chaim Gross on 04/06/2019.
//  Copyright © 2019 Sifra Digital. All rights reserved.
//

import Foundation
class Bookmark: NSObject, Identifiable{
    var id: Int = 0
    let shiurID: Int
    let title: String
    let progress: Double
    let time: Int
    
    init(id: Int, shiurID: Int, title: String, progress: Double, time: Int) {
        self.shiurID = shiurID
        self.title = title
        self.progress = progress
        self.time = time
        self.id = id
    }
    
    public func setID(id: Int) {
        self.id = id
    }
}
