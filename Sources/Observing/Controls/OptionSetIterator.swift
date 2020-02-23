//
//  OptionSetIterator.swift
//  Observations
//
//  Created by Antonio Nunes on 02/06/2019.
//  Source: https://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift

import Foundation

/// Note that we only accept unsigned integers, because the `next()` function may not produce correct results on signed integers or other types.
/// This limits us to traditional option sets that are usually built by defining the options through bit shifting.
public struct OptionSetIterator<Element: OptionSet>: IteratorProtocol where Element.RawValue == UInt {
    private let value: Element

    public init(element: Element) {
        self.value = element
    }

    private lazy var remainingBits = value.rawValue
	private var bitMask: Element.RawValue = 1

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

extension OptionSet where Self.RawValue == UInt {
   public func makeIterator() -> OptionSetIterator<Self> {
      return OptionSetIterator(element: self)
   }
}
