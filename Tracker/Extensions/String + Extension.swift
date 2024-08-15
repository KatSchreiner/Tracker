//
//  String + Extension.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 11.08.2024.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: self)
    }
}
