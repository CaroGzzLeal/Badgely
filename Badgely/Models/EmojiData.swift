//
//  EmojiData.swift
//  Badgely
//
//  Created by Mariel Perez on 07/10/25.
//
import SwiftUI

//EMOJI - FILTROS POR ICONO
struct EmojiData: Identifiable {
    let name: String
    let icon: String
    let id = UUID()

    static func examples() -> [EmojiData] {
        [EmojiData(name: "cafeteria", icon: "cup.and.heat.waves.fill"), EmojiData(name: "emblematico", icon: "building.columns.fill"), EmojiData(name: "evento", icon: "party.popper.fill"), EmojiData(name: "restaurante", icon: "fork.knife"), EmojiData(name: "voluntariado", icon: "globe.americas"), EmojiData(name: "vida_nocturna", icon: "wineglass"), EmojiData(name: "area_verde", icon: "mountain.2.fill")]
    }
}


// Global emoji para las dos views search y content
private struct EmojiDataKey: EnvironmentKey {
    static let defaultValue: [EmojiData] = EmojiData.examples()
}

extension EnvironmentValues {
    var emojiData: [EmojiData] {
        get { self[EmojiDataKey.self] }
        set { self[EmojiDataKey.self] = newValue }
    }
}
