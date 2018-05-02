//
//  Displayer.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//

import Foundation

public protocol IDisplayer {

    typealias Completion = () -> Void

    func display(from fromVC: UIViewController, to toVC: UIViewController, animated: Bool, complete: Completion?)

    func finishDisplay(_ vc: UIViewController, animated: Bool, complete: Completion?)

    func setNeedDisplay(_ vc: UIViewController, animated: Bool, complete: Completion?)
}



public extension IDisplayer {

    public func setNeedDisplay(_ vc: UIViewController, animated: Bool, complete: Completion?) {
        dismissTopViewControllers(vc, animated: animated) {
            _ = vc.navigationController?.ts.popToRootViewContoller(animated, completion: complete)
        }
    }

    func dismissTopViewControllers(_ vc: UIViewController, animated: Bool, completion: Completion?) {
        if let presented = vc.presentedViewController {
            dismissTopViewControllers(presented, animated: animated, completion: completion)
        }
        else if let completion = completion {
            completion()
        }
    }
}

public class PushPopDisplayer : IDisplayer {

    public func finishDisplay(_ vc: UIViewController, animated: Bool, complete: IDisplayer.Completion?) {
        guard let nav = vc.navigationController else {
            return
        }

        if let idx = nav.viewControllers.index(of: vc), idx > 0 {
            let _ = nav.ts.popToViewController(nav.viewControllers[idx - 1], animated: animated, completion: complete)
        } else {
            let _ = nav.ts.popToRootViewContoller(animated, completion: complete)
        }
    }

    public func display(from fromVC: UIViewController, to toVC: UIViewController, animated: Bool, complete: IDisplayer.Completion?) {
        guard let nav = fromVC.navigationController else {
            return
        }

        let _ = nav.ts.pushViewController(toVC, animated: animated, completion: complete)
    }


}


public extension Intent {
    public static func pushPop(_ url: String) -> Intent {
        let intent = Intent.intent(URL.init(string: url))
        intent.displayer = PushPopDisplayer()
        return intent
    }
}
