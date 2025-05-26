//
//  WidgetExtensionAttributes.swift
//  Library-iOS
//
//  Created by Jim Huang on 2025/5/15.
//

import ActivityKit
import Foundation

struct WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var deliveryTimer: ClosedRange<Date>
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
