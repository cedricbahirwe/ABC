//
//  CustomMovieController.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import AVKit
import UIKit

class CustomMovieController: AVPlayerViewController {
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        switch key.keyCode {
        case .keyboardSpacebar:
            player?.play()
        case .keyboardLeftArrow:
            player?.seek(to: .zero)
        default:
            super.pressesBegan(presses, with: event)
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        switch key.keyCode {
        case .keyboardSpacebar:
            player?.pause()
        default:
            super.pressesEnded(presses, with: event)
        }
    }
}
