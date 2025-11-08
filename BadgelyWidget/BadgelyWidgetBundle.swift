//
//  BadgelyWidgetBundle.swift
//  BadgelyWidget
//
//  Created by Carolina Nicole Gonzalez Leal on 20/10/25.
//

import WidgetKit
import SwiftUI

@main
struct BadgelyWidgetBundle: WidgetBundle {
    var body: some Widget {
        BadgelyWidget()
        BadgelyWidgetLiveActivity()
    }
}
