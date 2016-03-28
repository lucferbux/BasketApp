//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!

  var lastPoint = CGPoint.zero
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 3.0
  var opacity: CGFloat = 1.0
  var swiped = false
  
  let colors: [(CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (1.0, 1.0, 1.0),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Actions

  @IBAction func reset(sender: AnyObject) {
    mainImageView.image = UIImage(named: "Basket")
  }

  @IBAction func share(sender: AnyObject) {
    UIGraphicsBeginImageContext(mainImageView.bounds.size)
    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, 
      width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
     
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    presentViewController(activity, animated: true, completion: nil)
  }
  
  @IBAction func pencilPressed(sender: AnyObject) {
    
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count {
      index = 0
    }
    
    (red, green, blue) = colors[index]
    
    if index == colors.count - 1 {
      opacity = 1.0
    }
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    swiped = false
    if let touch = touches.first {
      lastPoint = touch.locationInView(self.view)
    }
  }
  
  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
    
    // 1
    UIGraphicsBeginImageContext(view.frame.size)
    let context = UIGraphicsGetCurrentContext()
    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    
    // 2
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
    
    // 3
    CGContextSetLineCap(context, CGLineCap.Round)
    CGContextSetLineWidth(context, brushWidth)
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
    CGContextSetBlendMode(context, CGBlendMode.Normal)
    
    // 4
    CGContextStrokePath(context)
    
    // 5
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
    
  }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    // 6
    swiped = true
    if let touch = touches.first {
      let currentPoint = touch.locationInView(view)
      drawLineFrom(lastPoint, toPoint: currentPoint)
      
      // 7
      lastPoint = currentPoint
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

    if !swiped {
      // draw a single point
      drawLineFrom(lastPoint, toPoint: lastPoint)
    }
    
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let settingsViewController = segue.destinationViewController as! SettingsViewController
    settingsViewController.delegate = self
    settingsViewController.brush = brushWidth
    settingsViewController.opacity = opacity
    settingsViewController.red = red
    settingsViewController.green = green
    settingsViewController.blue = blue
  }
  
}

extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
  }
}

