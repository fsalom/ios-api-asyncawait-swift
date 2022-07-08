//
//  ErrorDTO.swift
//  Template
//
//  Created by Fernando Salom on 4/1/22.
//  Copyright © 2022 Rudo. All rights reserved.
//

import Foundation

struct ErrorDTO: Codable {
  let title: String
  let description: String
// swiftlint:disable all
  enum CodingKeys: String, CodingKey {
    case title = "titulo"
    case description = "description"
  }
}
