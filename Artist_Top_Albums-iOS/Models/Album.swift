//
//  Album.swift
//  Artist_Top_Albums-iOS
//
//  Created by Med Salmen Saadi on 5/27/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import Foundation

struct Album {
    
    var name : String
    var playcount : String
    
    var artist : Artist
    var images: [Image] = []
    
}
