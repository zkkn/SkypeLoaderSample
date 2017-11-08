//
//  WorkSpace.swift
//  skype_logo_tutorial
//
//  Created by Shoichi Kanzaki on 2017/11/08.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import C4
import UIKit

class WorkSpace: CanvasController {
    
    // MARK - Views -
    
    var views = [View]()
    var circles = [Circle]()
    var container: View!
    
    // MARK - Properties -
    
    var animationTimer: C4.Timer!
    let duration = 3.0
    var viewAnimationGroup: ViewAnimationGroup!
    var circleAnimationGroup: ViewAnimationGroup!
    
    
    // MARK - Life Cycle Events -
    
    override func setup() {
        canvas.backgroundColor = Color(red: 64, green: 177, blue:239, alpha:1.0)
        
        createViewsCircles()
        createAnimations()
        startAnimationTimer()
        rotateContainerAnimation()
    }
}

// MARK - Setup -

extension WorkSpace {
    
    func createViewsCircles() {
        container = View(frame: Rect(0, 0, 1, 1))
        for _ in 1...4 {
            let v = View(frame: Rect(0,0,10,10))
            views.append(v)
            
            let c = Circle(center: v.center, radius: v.width/2.0)
            c.lineWidth = 10.0
            c.strokeColor = white
            c.fillColor = white
            circles.append(c)
            v.add(c)
            v.anchorPoint = Point(0.5, 7.5)
            v.center = container.center
            container.add(v)
        }
        canvas.add(container)
        container.center = canvas.center
    }
    
    func createAnimations() {
        var canims = [ViewAnimation]()
        var vanims = [ViewAnimation]()
        for i in 0..<views.count {
            let v = views[i]
            let offset = Double(i) * 0.1 + 0.05
            let va = ViewAnimation(duration: duration/4.0 + 0.3) {
                v.rotation += M_PI
            }
            va.delay = offset
            vanims.append(va)
            
            let c = circles[i]
            let ca = ViewAnimation(duration: duration/8.0 + 0.15) {
                c.lineWidth = 0.0
            }
            ca.delay = offset
            ca.autoreverses = true
            ca.addCompletionObserver {
                ShapeLayer.disableActions = true
                c.lineWidth = 10.0
                ShapeLayer.disableActions = false
            }
            canims.append(ca)
        }
        viewAnimationGroup = ViewAnimationGroup(animations: vanims)
        circleAnimationGroup = ViewAnimationGroup(animations: canims)
    }
    
    func startAnimationTimer() {
        animationTimer = C4.Timer(interval: duration/4.0) {
            self.viewAnimationGroup.animate()
            self.circleAnimationGroup.animate()
        }
        animationTimer.start()
        animationTimer.fire()
    }
    
    func rotateContainerAnimation() {
        let containerAnimation = ViewAnimation(duration: duration) {
            self.container.rotation += 2*M_PI
        }
        containerAnimation.curve = .Linear
        containerAnimation.repeats = true
        containerAnimation.animate()
    }
}
