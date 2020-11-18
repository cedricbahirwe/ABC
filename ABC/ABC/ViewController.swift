//
//  ViewController.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import AVKit
import UIKit
import SwiftUI

@available(iOS 13.0, *)

struct CancellableView: UIViewControllerRepresentable {
    var callback: () -> ()
    private let proxyController = ViewController()

    func makeUIViewController(context: UIViewControllerRepresentableContext<CancellableView>) -> UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CancellableView>) {
    }

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: () -> Void = { }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.perform(#selector(callBackHolder), with: nil, afterDelay: 1)
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
//            NSObject.cancelPreviousPerformRequests(withTarget: self)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(callBackHolder), object: nil)
        }
        
        @objc func callBackHolder() {
            self.callback()
        }
    }
}

 
class ViewController: UIViewController {
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let videoURL = URL(string: "https://bit.ly/aryashake")
        let vc = CustomMovieController()
        vc.player = AVPlayer(url: videoURL!)
        present(vc, animated: true)
    }
}

