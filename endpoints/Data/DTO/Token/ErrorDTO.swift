import Foundation

struct ErrorDTO: Codable {
  let title: String
  let description: String
  
  enum CodingKeys: String, CodingKey {
    case title = "titulo"
    case description = "description"
  }
}
