//
//  DataSetExport.swift
//  trendlines
//
//  Created by Grey Patterson on 5/8/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct DataSetExport: FileDocument {
    static var readableContentTypes: [UTType] {
        [UTType.commaSeparatedText]
    }
    
    var entries: [DataSetEntry]
    
    init(entries: [DataSetEntry]) {
        self.entries = entries
    }
    
    init(configuration: ReadConfiguration) throws {
        <#code#>
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        <#code#>
    }
    
    static func convertToCSVLine(entry: DataSetEntry) -> String {
        "\(entry.value),\(entry.dateAdded)"
    }
    
    func createCSV() -> String {
        var result = "Value,Date\n"
        let converted = entries.map(DataSetExport.convertToCSVLine)
        result += converted.joined(separator: "\n")
        return result
    }
}
