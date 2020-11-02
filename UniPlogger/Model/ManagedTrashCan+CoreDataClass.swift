//
//  ManagedTrashCan+CoreDataClass.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/02.
//  Copyright © 2020 손병근. All rights reserved.
//
//

import Foundation
import CoreData


public class ManagedTrashCan: NSManagedObject {
    func toTrashCan() -> TrashCan {
        return TrashCan(latitude: latitude, longitude: longitude, isRemoved: isRemoved)
    }
    
    func fromTrashCan(_ trashCan: TrashCan) {
        latitude = trashCan.latitude
        longitude = trashCan.longitude
        isRemoved = trashCan.isRemoved
    }
}
