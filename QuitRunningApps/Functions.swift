//
//  Functions.swift
//  QuitRunningApps
//
//  Created by Plamen Balinov on 1.09.22.
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
