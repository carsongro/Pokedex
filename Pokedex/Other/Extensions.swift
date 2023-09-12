//
//  Extensions.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI

extension String {
    func firstLetterCapitalized() -> String {
        prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

// From one of the solutions here: https://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
extension CGImage {
    var color: Color? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo),
              let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
            return nil
        }
        
        context.draw(self, in: CGRect(x: 0,
                                      y: 0,
                                      width: width,
                                      height: height))
        
        let i = bytesPerRow * (Int(height / 2)) + bytesPerPixel * (Int(width / 2))
        
        let r = CGFloat(ptr[i]) / 255.0
        let g = CGFloat(ptr[i+1]) / 255.0
        let b = CGFloat(ptr[i+2]) / 255.0
        let a = CGFloat(ptr[i+3]) / 255.0
        
        return Color(UIColor(red: r, green: g, blue: b, alpha: a))
    }
}
