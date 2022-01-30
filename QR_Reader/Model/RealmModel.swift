//
//  RealmModel.swift
//  QR_Reader
//
//  Created by MacBook Air on 26.01.2022.
//

import Foundation
import RealmSwift

class pastSites : Object {
    @objc dynamic var url : String?
    @objc dynamic var date : String?
}

class pastQr : Object {
    @objc dynamic var url : String?
    @objc dynamic var name : String?
}

