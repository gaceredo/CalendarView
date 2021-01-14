//
//  CalendarViewApp.swift
//  CalendarView
//
//  Created by Luis Aceredo on 14/01/21.
//

import SwiftUI

@main
struct CalendarViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(tap: { day in
                print(day)
            })
        }
    }
}
