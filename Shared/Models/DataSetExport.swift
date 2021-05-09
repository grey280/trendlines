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
        if let data = configuration.file.regularFileContents {
            let decodedText = String(decoding: data, as: UTF8.self)
            let parsed = DataSetExport.convert(csv: decodedText, dataSetID: 0)
            entries = parsed
        } else {
            entries = []
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let mapped = createCSV()
        let data = Data(mapped.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
    
    private static func convertToCSVLine(entry: DataSetEntry) -> String {
        "\(entry.value),\(dateFormatter.string(from: entry.dateAdded))"
    }
    
    private static func convert(csvLine: String, dataSetID: DataSet.ID) -> DataSetEntry? {
        let split = csvLine.split(separator: ",").map(String.init)
        guard split.count == 2 else {
            return nil
        }
        guard let value = Double(split[0]) else {
            return nil
        }
        guard let date = dateFormatter.date(from: split[1]) else {
            return nil
        }
        return DataSetEntry(id: nil, dateAdded: date, value: value, datasetID: dataSetID)
    }
    
    static func convert(csv: String, dataSetID: DataSet.ID) -> [DataSetEntry] {
        let splitText = csv.split(separator: "\n").map(String.init)
        guard splitText.count > 1 else {
            return []
        }
        let parsed = splitText.compactMap {
            // convert will fail on first line, return nil, and be erased by CompactMap
            DataSetExport.convert(csvLine: $0, dataSetID: dataSetID)
        }
        return parsed
    }
    
    private static var dateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withFullTime]
        return f
    }()
    
    private func createCSV() -> String {
        var result = "Value,Date\n"
        let converted = entries.map(DataSetExport.convertToCSVLine)
        result += converted.joined(separator: "\n")
        return result
    }
}
