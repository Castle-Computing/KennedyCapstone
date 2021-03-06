//
//  ResultPage.swift
//  App
//
//  Created by tigeriv on 10/25/18.
//

final class Results: Codable {
    let results: [docArray]
    init(results: [docArray]) {
        self.results = results
    }
}
final class ResultPage: Codable {
    let query: Query
    let searchResults: [docArray]
    let numberOfResults: Int
    let start: Int
    let page: Int

    init(query: Query, searchResults: [docArray], numResults: Int, start: Int, page: Int) {
        self.query = query
        self.searchResults = searchResults
        self.numberOfResults = numResults
        self.start = start
        self.page = page
    }
}

struct SearchResult: Codable {
    let response: searchResponse
}

struct searchResponse: Codable {
    let numFound: Int
    let start: Int
    let docs: [docArray]
}

final class docArray: Codable {
    var titleArray: [String]?
    var title: String?

    var authorPlaceholder: String?
    var author: String?

    var descriptionArray: [String]?
    var ocrText: String?
    var description: String?

    var datePlaceholder: String?
    var date: String?

    var cityPlaceholder: String?
    var statePlaceholder: String?
    var location: String?

    var children: [String]?

    var pid: String
    
    var prevLetter: String?
    var nextLetter: String?
    
    var relatedObjects: String?

    enum CodingKeys: String, CodingKey {
        case titleArray = "dc.title"
        case title = "title"
        case authorPlaceholder = "mods_name_personal_author_namePart_s"
        case author = "author"
        case descriptionArray = "dc.description"
        case ocrText = "OCR_BOOK_t"
        case description = "description"
        case pid = "PID"
        case datePlaceholder = "mods_originInfo_dateCreated_s"
        case date = "date"
        case cityPlaceholder = "mods_subject_hierarchicalGeographic_city_s"
        case statePlaceholder = "mods_subject_hierarchicalGeographic_state_s"
        case location = "location"
        case children = "BOOK_CHILDREN_t"
        case prevLetter = "PREVIOUS_MORGAN_LETTER_t"
        case nextLetter = "NEXT_MORGAN_LETTER_t"
        case relatedObjects = "RELATED_OBJECTS_t"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pid = try container.decode(String.self, forKey: .pid)
        
        do {
            titleArray = try container.decode([String].self, forKey: .titleArray)
            title = titleArray![0]
        } catch {
            debugPrint("No title listed.")
        }


        do {
            authorPlaceholder = try container.decode(String.self, forKey: .authorPlaceholder)
            author = authorPlaceholder
        } catch {
            debugPrint("No author listed.")
        }

        do {
            datePlaceholder = try container.decode(String.self, forKey: .datePlaceholder)
            date = datePlaceholder
        } catch {
            debugPrint("No date listed.")
        }

        do {
            let childrenString = try container.decode(String.self, forKey: .children)
            children = childrenString.components(separatedBy: ",")
        } catch {
            debugPrint("No children listed.")
        }
        
        do {
            let prevLetterString = try container.decode(String.self, forKey: .prevLetter)
            prevLetter = prevLetterString
            
            let nextLetterString = try container.decode(String.self, forKey: .nextLetter)
            nextLetter = nextLetterString
        } catch {
            debugPrint("No prev/next listed.")
        }
        
        do {
            let relatedObjectsString = try container.decode(String.self, forKey: .relatedObjects)
            relatedObjects = relatedObjectsString
        } catch {
            debugPrint("No related objects listed.")
        }

        do {
            cityPlaceholder = try container.decode(String.self, forKey: .cityPlaceholder)
            statePlaceholder = try container.decode(String.self, forKey: .statePlaceholder)
        } catch {
            debugPrint("No location listed.")
        }

        do {
            ocrText = try container.decode(String.self, forKey: .ocrText)
        } catch {
            debugPrint("No ocr included.")
        }
        

        if cityPlaceholder?.count ?? 0 > 0 && statePlaceholder?.count ?? 0 > 0 {
            location = cityPlaceholder! + ", " + statePlaceholder!
        } else if cityPlaceholder?.count ?? 0 > 0 {
            location = cityPlaceholder
        } else if statePlaceholder?.count ?? 0 > 0 {
            location = statePlaceholder
        }

        do {
            descriptionArray = try container.decode([String].self, forKey: .descriptionArray)
            if descriptionArray?.count ?? 0 > 0 && descriptionArray![0].count > 0 {
                description = descriptionArray![0]
            } else if let temp = ocrText {
                description = String(temp.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false).last!.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "&apos;", with: "'").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "�", with: "").replacingOccurrences(of: "&amp;", with: "&"))

                if description?.count ?? 0 > 250 {
                    description = description!.prefix(200) + "..."
                }
            } else {
                debugPrint("No valid description or OCR listed.")
            }
        } catch {
            if let temp = ocrText {
                description = String(temp.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false).last!.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "&apos;", with: "'").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "�", with: "").replacingOccurrences(of: "&amp;", with: "&"))

                if description?.count ?? 0 > 250 {
                    description = description!.prefix(200) + "..."
                }
            } else {
                debugPrint("No description or OCR listed.")
            }

        }
    }
}
