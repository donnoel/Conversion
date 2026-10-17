// Compose genuine captures with Apple frameworks; never redraw in-app UI.
import AppKit
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "docs/app-store/screenshot-redesign-2026-10-17")
let fm = FileManager.default
let ink = NSColor(srgbRed: 0.08, green: 0.16, blue: 0.26, alpha: 1)
let blue = NSColor(srgbRed: 0.16, green: 0.40, blue: 0.72, alpha: 1)
let muted = NSColor(srgbRed: 0.32, green: 0.39, blue: 0.48, alpha: 1)
struct Card { let key: String; let title: String; let detail: String }
let cards = [
    Card(key: "convert", title: "Everyday units.\nInstant answers.", detail: "Type a value. Convert as you go."),
    Card(key: "toolkit", title: "One value.\nRelated units.", detail: "See related units together in Toolkit."),
    Card(key: "favorites", title: "Your favorites,\nready to use.", detail: "Keep your go-to pairs at the top of Units."),
    Card(key: "choose", title: "Find the right units.", detail: "Browse categories or search for a pair.")
]
func load(_ path: String) throws -> CGImage {
    let u = root.appendingPathComponent(path)
    guard let s = CGImageSourceCreateWithURL(u as CFURL, nil), let i = CGImageSourceCreateImageAtIndex(s, 0, nil) else {
        throw NSError(domain: "StoreCaptures", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing \(u.path)"])
    }
    return i
}
func canvas(_ w: Int, _ h: Int, _ draw: (CGContext) throws -> Void) rethrows -> CGImage {
    let c = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    c.interpolationQuality = .high
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext: c, flipped: false)
    try draw(c)
    NSGraphicsContext.restoreGraphicsState()
    return c.makeImage()!
}
func text(_ s: String, _ rect: CGRect, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = ink, alignment: NSTextAlignment = .left) {
    let p = NSMutableParagraphStyle(); p.alignment = alignment; p.lineBreakMode = .byWordWrapping
    let font = NSFont.systemFont(ofSize: size, weight: weight)
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color, .paragraphStyle: p]
    let measured = (s as NSString).boundingRect(with: CGSize(width: rect.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attrs)
    precondition(measured.height <= rect.height + 2, "Caption does not fit: \(s)")
    (s as NSString).draw(in: rect, withAttributes: attrs)
}
func write(_ i: CGImage, _ path: String) throws {
    let u = root.appendingPathComponent(path); try fm.createDirectory(at: u.deletingLastPathComponent(), withIntermediateDirectories: true)
    let d = CGImageDestinationCreateWithURL(u as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(d, i, nil); precondition(CGImageDestinationFinalize(d))
}
func fit(_ i: CGImage, into r: CGRect, context c: CGContext, radius: CGFloat = 28) {
    let scale = min(r.width / CGFloat(i.width), r.height / CGFloat(i.height))
    let w = CGFloat(i.width) * scale, h = CGFloat(i.height) * scale
    let dst = CGRect(x: r.midX-w/2, y: r.midY-h/2, width: w, height: h)
    c.saveGState(); c.addPath(CGPath(roundedRect: dst, cornerWidth: radius, cornerHeight: radius, transform: nil)); c.clip(); c.draw(i, in: dst); c.restoreGState()
}
var manifest: [[String: Any]] = []
for platform in ["iphone", "ipad"] {
    let pad = platform == "ipad"
    let w = pad ? 2064 : 1320, h = pad ? 2752 : 2868
    var outputs: [CGImage] = []
    for (idx, card) in cards.enumerated() {
        let raw = "raw/\(platform)-\(card.key).png", image = try load(raw)
        let output = "\(platform)/\(String(format: "%02d", idx+1))-\(card.key).png"
        // Remove system status chrome; tighten the iPad picker to its genuine modal.
        // No content is repainted or recombined.
        let top = pad ? 54 : 140
        let crop = pad && idx == 3
            ? CGRect(x: 430, y: 690, width: 1204, height: 1360)
            : CGRect(x: 0, y: top, width: image.width, height: image.height-top)
        let capture = image.cropping(to: crop)!
        let composed = canvas(w,h) { c in
            let colors: [NSColor] = idx == 1 ? [NSColor(srgbRed: 0.96, green: 0.99, blue: 0.99, alpha: 1), NSColor(srgbRed: 0.88, green: 0.95, blue: 0.97, alpha: 1)] : [NSColor(srgbRed: 0.985, green: 0.985, blue: 1, alpha: 1), NSColor(srgbRed: 0.92, green: 0.94, blue: 0.99, alpha: 1)]
            NSGradient(colors: colors)!.draw(in: CGRect(x: 0,y: 0,width: w,height: h), angle: -65)
            let margin: CGFloat = pad ? 110 : 80
            let header: CGFloat = pad ? 350 : 480
            if pad {
                text("EASY UNITS", CGRect(x: margin,y: CGFloat(h)-95,width: 700,height: 50), size: 31, weight: .semibold, color: blue)
                text(card.title.replacingOccurrences(of: "\n", with: " "), CGRect(x: margin,y: CGFloat(h)-215,width: CGFloat(w)-2*margin,height: 110), size: 79, weight: .semibold)
                text(card.detail, CGRect(x: margin,y: CGFloat(h)-285,width: CGFloat(w)-2*margin,height: 65), size: 38, color: muted)
            } else if idx == 3 {
                text("EASY UNITS", CGRect(x: margin,y: 340,width: 800,height: 50), size: 29, weight: .semibold,color: blue)
                text("Find the\nright units.", CGRect(x: margin,y: 135,width: CGFloat(w)-2*margin,height: 205), size: 81, weight: .semibold)
                text(card.detail, CGRect(x: margin,y: 55,width: CGFloat(w)-2*margin,height: 65), size: 34,color: muted)
            } else {
                text("EASY UNITS", CGRect(x: margin,y: CGFloat(h)-105,width: 900,height: 50), size: 29,weight: .semibold,color: blue)
                text(card.title, CGRect(x: margin,y: CGFloat(h)-330,width: CGFloat(w)-2*margin,height: 215), size: 84,weight: .semibold)
                text(card.detail, CGRect(x: margin,y: CGFloat(h)-414,width: CGFloat(w)-2*margin,height: 70), size: 35,color: muted)
            }
            let region = (!pad && idx == 3) ? CGRect(x: 52,y: 470,width: CGFloat(w)-104,height: CGFloat(h)-520) : CGRect(x: pad ? 70 : 52,y: 40,width: CGFloat(w)-(pad ? 140 : 104),height: CGFloat(h)-header-40)
            fit(capture, into: region, context: c, radius: pad ? 32 : 30)
        }
        try write(composed,output); outputs.append(composed)
        manifest.append(["platform":platform,"sequence":idx+1,"file":output,"caption":card.title.replacingOccurrences(of:"\n",with:" "),"detail":card.detail,"raw":raw,"sourceCrop": [Int(crop.minX),Int(crop.minY),Int(crop.width),Int(crop.height)],"width":w,"height":h,"status":"proposed; not approved or uploaded"])
    }
    let cw = pad ? 430 : 300, ch = Int(Double(cw)*Double(h)/Double(w))
    let sheet = canvas(4*cw+100,ch+150) { c in
        NSColor.white.setFill(); NSRect(x:0,y:0,width:4*cw+100,height:ch+150).fill()
        text("Easy Units · \(pad ? "iPad" : "iPhone") · proposed sequence",CGRect(x:24,y:CGFloat(ch)+92,width:CGFloat(4*cw),height:44),size:26,weight:.semibold)
        for (i,im) in outputs.enumerated() {
            c.draw(im,in:CGRect(x:25+i*(cw+15),y:55,width:cw,height:ch))
            text(String(format:"%02d",i+1),CGRect(x:CGFloat(25+i*(cw+15)),y:12,width:200,height:30),size:19,color:muted)
        }
    }
    try write(sheet,"\(platform)-sequence.png")
}
let data = try JSONSerialization.data(withJSONObject: manifest, options:[.prettyPrinted,.sortedKeys])
try data.write(to:root.appendingPathComponent("manifest.json"),options:.atomic)
print("Rendered 8 proposed screenshots, two contact sheets, and manifest.")
