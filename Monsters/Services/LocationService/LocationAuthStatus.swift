//
//  LocationAuthStatus.swift
//  Monsters
//
//  Created by Maxim Alekseev on 03.01.2021.
//

import Foundation

enum LocationAuthStatus {
    case notDetermined
    case denied
    case granted
    
    var status: String {
        
        switch self {
                                
        case .notDetermined:
            return "Не получается определить ваше местоположение!"
        case .denied:
            return "Приложение не знает где вы находитесь. Дайте приложению доступ для определения вашего местоположения в настройках устройства!"
        case .granted:
            return "Все хорошо! Определяем ваше местоположение"
        }
    }
}
