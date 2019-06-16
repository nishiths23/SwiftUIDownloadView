import SwiftUI
import Combine

struct SwiftUIDownloadView : View {
    var size: CGFloat = 40
    var progress: Float 
    var action: () -> Void
    @ObjectBinding private var circle = AnimationCircle()
    
    init(progress: Float, action: @escaping () -> Void) {
        self.progress = progress
        self.action = action
        circle.percentage = progress
    }
    
    var body: some View {
        VStack {
            ZStack{
                Circle(startAngleRadians: circle.startAngleRadians,
                       endAngleRadians: circle.endAngleRadians,
                       close: circle.close)
                    .rotation(.degrees(circle.currentAngle))
                    .fill(Color.Gray.medium)
                if circle.showProgress {
                    Button(action: action) {
                        ZStack {
                            ProgressButtonCircle(startAngleRadians: circle.progressStartAngleRadians,
                                                 endAngleRadians: circle.progressEndAngleRadians)
                                .fill(Color.Blue.medium)
                            ProgressBurronSquare()
                            .fill(Color.Blue.medium)
                        }
                    }
                }
            }.frame(width: size, height: size, alignment: Alignment.center)
        }
    }
}

struct Circle: Shape, Animatable {
    var lineWidth: CGFloat = 2
    var startAngleRadians: CGFloat
    var endAngleRadians: CGFloat
    var close: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let radius = min(rect.width / 2, rect.height / 2) - (lineWidth * 4)
        p.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2),
                 radius: radius,
                 startAngle: Angle(degrees: Double(startAngleRadians)),
                 endAngle: Angle(degrees: Double(endAngleRadians)),
                 clockwise: true)
        if close {
            p.closeSubpath()
        }
        let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        return p.strokedPath(style)
    }
}

struct ProgressButtonCircle: Shape {
    var lineWidth: CGFloat = 2
    var startAngleRadians: CGFloat
    var endAngleRadians: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let radius = min(rect.width / 2, rect.height / 2) - (lineWidth * 4)
        p.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2),
                 radius: radius,
                 startAngle: Angle(degrees: Double(startAngleRadians)),
                 endAngle: Angle(degrees: Double(endAngleRadians)),
                 clockwise: false)
        let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        return p.strokedPath(style)
    }
}

struct ProgressBurronSquare: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let minWidth = min(rect.width / 2, rect.height / 2)/2
        p.addRoundedRect(in: CGRect(x: minWidth + (minWidth/2), y: minWidth + (minWidth/2), width: minWidth, height: minWidth),
                         cornerSize: CGSize(width: 3, height: 3))
        return p
    }
    
    
}


class AnimationCircle: BindableObject {
    let didChange = PassthroughSubject<AnimationCircle, Never>()
    
    var percentage: Float = 0.0 {
        didSet {
            if percentage > 0 {
                if timer != nil{
                    timer?.invalidate()
                    timer = nil
                }
                if endAngleRadians != CGFloat.pi / 2{
                    endAngleRadians = CGFloat.pi
                }
                if close == false{
                    close = true
                }
                if showProgress == false{
                    showProgress = true
                }
                progressEndAngleRadians = (CGFloat(percentage) * 360) + progressStartAngleRadians
                withAnimation {
                    didChange.send(self)
                }
            }
        }
    }
    
    private(set) var currentAngle : Double = 0 {
        didSet {
            didChange.send(self)
        }
    }

    private(set) var startAngleRadians: CGFloat = -CGFloat.pi / 2
    private(set) var endAngleRadians: CGFloat = 6 * CGFloat.pi
    private(set) var progressStartAngleRadians: CGFloat = -90
    private(set) var progressEndAngleRadians: CGFloat = 270
    private(set) var close: Bool = false
    private(set) var showProgress: Bool = false
    private var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {[weak self] _ in
            withAnimation {
                self?.currentAngle += 1
            }
        }
    }
}

extension Color {

    enum Gray {
        static let light = Color(red: 245.0 / 255.0, green: 244.0 / 255.0, blue: 249.0 / 255.0)
        static let medium = Color(red: 238.0 / 255.0, green: 239.0 / 255.0, blue: 245.0 / 255.0)
        static let dark = Color(red: 229.0 / 255.0, green: 229.0 / 255.0, blue: 233.0 / 255.0)
    }

    enum Blue {
        static let light = Color(red: 199.0 / 255.0, green: 222 / 255.0, blue: 243 / 255.0)
        static let medium = Color(red: 9.0 / 255.0, green: 111.0 / 255.0, blue: 227.0 / 255.0)
    }

}
