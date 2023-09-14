//
//  Extensions.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI

extension Animation {
    static var edgeBounce: Animation {
        Animation.timingCurve(0.27, 0.13, 0.09, 1)
    }
    
    static func edgeBounce(duration: TimeInterval = 0.2) -> Animation {
        Animation.timingCurve(0.27, 0.13, 0.09, 1, duration: duration)
    }
    
    static var easeInOutBack: Animation {
        Animation.timingCurve(0.33, -0.28, 0.42, 0.96)
    }
    
    static func easeInOutBack(duration: TimeInterval = 0.2) -> Animation {
        Animation.timingCurve(0.33, -0.28, 0.42, 0.96, duration: duration)
    }
}

extension String {
    func firstLetterCapitalized() -> String {
        prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIDevice {
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isLandscape = UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
}

struct RelativeHStack: Layout {
    var spacing = 0.0
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewFrame = frames(for: subviews, in: width)
        let lowestView = viewFrame.max { $0.maxY < $1.maxY } ?? .zero
        return CGSize(width: width, height: lowestView.maxY)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let viewFrames = frames(for: subviews, in: bounds.width)
        
        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.midY)
            subviews[index].place(at: position, anchor: .leading, proposal: ProposedViewSize(frame.size))
        }
    }
    
    func frames(for subviews: Subviews, in totalWidth: Double) -> [CGRect] {
        let totalSpacing = spacing * Double(subviews.count - 1)
        let availableWidth = totalWidth - totalSpacing
        let totalPriorities = subviews.reduce(0) { $0 + $1.priority }
        
        var viewFrames = [CGRect]()
        var x = 0.0
        
        for subview in subviews {
            let subviewWidth = availableWidth * subview.priority / totalPriorities
            let proposal = ProposedViewSize(width: subviewWidth, height: nil)
            let size = subview.sizeThatFits(proposal)
            
            let frame = CGRect(x: x, y: 0, width: size.width, height: size.height)
            viewFrames.append(frame)
            
            x += size.width + spacing
        }
        
        return viewFrames
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
