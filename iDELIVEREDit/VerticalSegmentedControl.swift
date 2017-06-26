//
//  VerticalSegmentedControl.swift
//  iDELIVEREDit
//
//  Created by Steven Kanceruk on 12/21/16.
//  Copyright © 2016 Catenaut, Inc. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func goVertical() {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        for segment in self.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
                }
            }
        }
    }
    func restoreHorizontal() {
        self.transform = CGAffineTransform.identity
        for segment in self.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform.identity
                }
            }
        }
    }
}
