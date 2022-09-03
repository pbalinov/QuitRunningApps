//
//  Functions.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

func openURL(_ link: String)
{
    if let url = URL(string: link)
    {
        NSWorkspace.shared.open(url)
    }
}

func openBundlePDF(_ pdf: String)
{
    if let pathToPDF = Bundle.main.path(forResource: pdf, ofType: "pdf")
    {
        let pdfURL = URL(fileURLWithPath: pathToPDF)
        NSWorkspace.shared.open(pdfURL)
    }
}

func validateString(_ str: String?) -> Bool
{
    // Return true if string is not null
    // or empty otherwise return false
    
    // Check if the string is nil
    guard let validateString = str else
    {
        // String is nil
        return false
    }
        
    // String is not nil, check if empty
    return !validateString.isEmpty
}
