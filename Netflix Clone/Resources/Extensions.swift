//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 21/06/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
