//  DairyListModel.swift
//  DIARY APP
//
//  Created by Bhavik Darji on 03/12/20.
//

import Foundation
import ObjectMapper

class DiaryJSONModel: Mappable {
    
    var id: String?
    var title: String?
    var content: String?
    var date: String?
    var displaydate: Date?

    required init(){
        
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        date <- map["date"]
        displaydate <- map["displaydate"]

    }
}
