import SwiftUI
import CoreGraphics

struct CirclePartShape: Shape {
    
    var endAngle: Double = 270
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x:rect.midX,y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = Angle(degrees: 140)
        let endAngle = Angle(degrees: endAngle)
        
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + radius * cos(CGFloat(startAngle.radians)), y: center.y + radius * sin(CGFloat(startAngle.radians))))
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        
        return path
    }
}

