//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Jim Huang on 2025/5/15.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
