//
//  ImageLocator.swift
//  Logic
//
//  Created by Devin Abbott on 10/1/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import Foundation

enum ImageLocator {
    static func image(named name: String) -> NSImage? {
        let bundle = BundleLocator.getBundle()
        guard let url = bundle.url(forResource: name, withExtension: "png") else { return nil }
        return NSImage(byReferencing: url)
    }
}

public enum MenuThumbnailImage {

    // Documentation
    public static let paragraph = ImageLocator.image(named: "menu-thumbnail-paragraph")!
    public static let h1 = ImageLocator.image(named: "menu-thumbnail-h1")!
    public static let h2 = ImageLocator.image(named: "menu-thumbnail-h2")!
    public static let h3 = ImageLocator.image(named: "menu-thumbnail-h3")!
    public static let divider = ImageLocator.image(named: "menu-thumbnail-divider")!
    public static let image = ImageLocator.image(named: "menu-thumbnail-image")!

    // Tokens
    public static let tokens = ImageLocator.image(named: "menu-thumbnail-tokens")!
    public static let function = ImageLocator.image(named: "menu-thumbnail-function")!
    public static let variable = ImageLocator.image(named: "menu-thumbnail-variable")!
    public static let newValue = ImageLocator.image(named: "menu-thumbnail-new-value")!
}