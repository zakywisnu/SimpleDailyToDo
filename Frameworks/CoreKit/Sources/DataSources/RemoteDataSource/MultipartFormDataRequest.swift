//
//  MultipartFormDataRequest.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import Foundation

public struct MultipartFormDataRequest {
    private var httpBody = NSMutableData()

    public let boundary: String = UUID().uuidString

    public var body: Data {
        return httpBody as Data
    }

    public func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value) as Data)
    }

    public func addDataField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(fieldName: fieldName, fileName: fileName, data: data, mimeType: mimeType))
    }

    public func addEndField() {
        httpBody.append("--\(boundary)--")
    }

    private func dataFormField(
        fieldName: String,
        fileName: String,
        data: Data,
        mimeType: String
    ) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }

    private func textFormField(named name: String, value: String) -> Data {
        let fieldData = NSMutableData()
        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("\r\n")
        fieldData.append("\(value)\r\n")

        return fieldData as Data
    }
}

public extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
