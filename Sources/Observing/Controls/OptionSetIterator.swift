//
//  OptionSetIterator.swift
//  Observations
//
//  Created by Antonio Nunes on 02/06/2019.
//  Source: https://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift

import Foundation

public struct OptionSetIterator<Element: OptionSet>: IteratorProtocol where Element.RawValue == UInt {
    private let value: Element

    public init(element: Element) {
        self.value = element
    }

    private lazy var remainingBits = value.rawValue
    private var bitMask: UInt = 1

    public mutating func next() -> Element? {
        while remainingBits != 0 {
            defer { bitMask = bitMask &* 2 }
            if remainingBits & bitMask != 0 {
                remainingBits = remainingBits & ~bitMask
                return Element(rawValue: bitMask)
            }
        }
        return nil
    }
}
