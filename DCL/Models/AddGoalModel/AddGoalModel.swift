//
//  AddGoalModel.swift
//  DCL
//
//  Created by Nikita on 2/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import ObjectMapper

class AddGoalModel {
    var items: [AddGoalItemModel]?
    
    init() {
        let item1 = AddGoalItemModel(state: true, type: IdeaLevel.Easy, color: DefaultGradient.easyColor)
        let item2 = AddGoalItemModel(state: false, type: IdeaLevel.Medium, color: DefaultGradient.mediumColor)
        let item3 = AddGoalItemModel(state: false, type: IdeaLevel.Hard, color: DefaultGradient.hardColor)
        items = [item1, item2, item3]
    }
    
    func updateModel(_ index: Int) {
        guard let items = self.items else { return}
        for item in items {
            item.state = false
        }
        items[index].state = true
    }   
}

class AddGoalItemModel: ResponseSimpleModel, Meta {
    
    var id      : Int?
    var state   : Bool!
    var text    : String!
    var color   : UIColor!    
    var type    : IdeaLevel!
    var image   : UIImage!
   
    override init() {
        super.init()
        self.state = false
        self.type = IdeaLevel.None
        self.text = ""
    }
    
    init(state: Bool, type: IdeaLevel,color: UIColor, text: String = "") {
        self.state = state
        self.type = type
        self.text = text
        self.color = color
        if type == IdeaLevel.Easy {
            self.image = #imageLiteral(resourceName: "green_ballon_add_goal")
        } else if type == IdeaLevel.Medium {
            self.image = #imageLiteral(resourceName: "blue_ballon_add_goal")
        }else if type == IdeaLevel.Hard {
            self.image = #imageLiteral(resourceName: "red_ballon_add_goal")
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id <- map["result.id"]
    }
    
    static func convertTypeToColor(_ type: IdeaLevel) -> UIColor {
        if type == IdeaLevel.Easy {
            return DefaultGradient.easyColor
        } else if type == IdeaLevel.Medium {
            return DefaultGradient.mediumColor
        }else if type == IdeaLevel.Hard {
            return DefaultGradient.hardColor
        }
        return UIColor.white
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.add_goal)
        }
    }
}

