//
//  NetworkApiMethods.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

enum NetworkApiMethods: String {

    case character
    case location
    case episode

    var path: String {
        let generalPath = #"/api/"#
        return generalPath+self.rawValue
    }}
