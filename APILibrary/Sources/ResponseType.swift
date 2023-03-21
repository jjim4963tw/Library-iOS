//
//  File.swift
//  
//
//  Created by Jim Huang on 2023/3/21.
//

import Foundation

public enum ResponseType {
    public enum DataType {
        case Json
        case XML
    }
    
    public enum Result {
        case Success(String)
        case Error(Int?, String)
    }
}
