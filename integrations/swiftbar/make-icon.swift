// Regenerate the SwiftBar plugin's embedded menu-bar icons from the source art
// in icons/. Converts white-on-black PNGs to monochrome template PNGs (alpha from
// the shape), crops, downscales to an 18pt-tall @2x image, and prints the base64
// to paste into adderall.5s.sh (PILL_IMG = pill.png, PILL_TIMER_IMG = pill-w-timer.png).
//   cd integrations/swiftbar && swift make-icon.swift
import AppKit
import CoreImage
func templatize(_ src: String) -> String {
  let ci = CIImage(contentsOf: URL(fileURLWithPath: src))!.applyingFilter("CIMaskToAlpha")
  let cg = CIContext(options: [.workingColorSpace: NSNull()]).createCGImage(ci, from: ci.extent)!
  let w = cg.width, h = cg.height, bpr = cg.bytesPerRow
  let ptr = CFDataGetBytePtr(cg.dataProvider!.data!)!
  var minX=w,minY=h,maxX = -1,maxY = -1
  for y in 0..<h { for x in 0..<w { if ptr[y*bpr+x*4+3] > 40 {
    if x<minX{minX=x}; if x>maxX{maxX=x}; if y<minY{minY=y}; if y>maxY{maxY=y} } } }
  let cw=maxX-minX+1, ch=maxY-minY+1
  let cropped = cg.cropping(to: CGRect(x:minX,y:minY,width:cw,height:ch))!
  let sh=44, sw=Int((44.0*CGFloat(cw)/CGFloat(ch)).rounded())
  let ctx = CGContext(data:nil,width:sw,height:sh,bitsPerComponent:8,bytesPerRow:0,
    space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
  ctx.interpolationQuality = .high
  ctx.draw(cropped, in: CGRect(x:0,y:0,width:sw,height:sh))
  let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
  rep.size = NSSize(width: CGFloat(sw)*18.0/CGFloat(sh), height: 18)
  return rep.representation(using:.png, properties:[:])!.base64EncodedString()
}
print("PILL_IMG=\"\(templatize("icons/pill.png"))\"")
print("PILL_TIMER_IMG=\"\(templatize("icons/pill-w-timer.png"))\"")
