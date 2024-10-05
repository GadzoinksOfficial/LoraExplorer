//
//  SafeTensorMetadata.swift
//  LoraExplorer
//
//  Created by Neal Katz on 10/2/24.
// claude.ai


import Foundation
import SwiftyJSON

struct SafeTensorMetadata {
    static func readMetadata(from filePath: String) -> JSON? {
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            print("Unable to open file")
            return nil
        }
        
        defer {
            fileHandle.closeFile()
        }
        
        // Read the first 8 bytes to get the header length
         let headerLengthData = fileHandle.readData(ofLength: 8)
        
        let headerLength = headerLengthData.withUnsafeBytes { $0.load(as: UInt64.self) }
        
        // Read the header
         let headerData = fileHandle.readData(ofLength: Int(headerLength))
        
        let json = JSON(headerData)
        return json
        // Parse the JSON header
        /*
        do {
            if let metadata = try JSONSerialization.jsonObject(with: headerData, options: []) as? [String: Any] {
                return metadata
            } else {
                print("Unable to parse metadata as dictionary")
                return nil
            }
        } catch {
            print("Error parsing metadata: \(error)")
            return nil
        }
         */
    }
}
/*
// Usage
let filePath = "/path/to/your/lora_file.safetensors"
if let metadata = SafeTensorMetadata.readMetadata(from: filePath) {
    print("Metadata:")
    for (key, value) in metadata {
        print("\(key): \(value)")
    }
} else {
    print("Failed to read metadata")
}
*/
