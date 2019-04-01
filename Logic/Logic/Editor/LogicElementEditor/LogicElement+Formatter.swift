//
//  LogicElementEditor+Formatter.swift
//  LogicDesigner
//
//  Created by Devin Abbott on 2/19/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import AppKit

extension LogicElement: FormattableElement {
    public var width: CGFloat {
        return measured(selected: false, offset: .zero).backgroundRect.width
    }
}