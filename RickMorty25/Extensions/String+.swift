//
//  String+.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 06.04.2025.
//

import UIKit

extension String {
    var extractedId: Int64? {
        return Int64(self.split(separator: "/").last ?? "")
    }
}
