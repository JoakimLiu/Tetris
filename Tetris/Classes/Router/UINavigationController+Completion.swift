//
//  UINavigationController+Completion.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/4/28.
//


import Foundation

extension UIViewController : TetrisNamespacing {
}

extension _TetrisNamespaceWrapper where Subject : UINavigationController {

    private func executeWithCompletion(_ completion: IDisplayer.Completion?, animted: Bool) {
        if let completion = completion, animted {
            DispatchQueue.main.async {
                completion()
            }
        }
        else if let completion = completion {
            obj.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (contex) in
                completion()
            })
        }
    }

    public func setViewControllers(_ vcs: [UIViewController], animated: Bool = true, completion: IDisplayer.Completion? = nil) {
        obj.setViewControllers(vcs, animated: animated)
        executeWithCompletion(completion, animted: animated)
    }

    public func pushViewController(_ vc: UIViewController, animated: Bool = true, completion: IDisplayer.Completion? = nil) {
        obj.pushViewController(vc, animated: animated)
        executeWithCompletion(completion, animted: animated)
    }

    public func popViewController(_ animated: Bool = true, completion: IDisplayer.Completion? = nil) -> UIViewController? {
        let vc = obj.popViewController(animated: animated)
        executeWithCompletion(completion, animted: animated)
        return vc
    }

    public func popToViewController(_ vc: UIViewController, animated: Bool = true, completion: IDisplayer.Completion? = nil) -> [UIViewController]? {
        let vcs = obj.popToViewController(vc, animated: animated)
        executeWithCompletion(completion, animted: animated)
        return vcs
    }

    public func popToRootViewContoller(_ animated: Bool = true, completion: IDisplayer.Completion? = nil) -> [UIViewController]? {
        let vcs = obj.popToRootViewController(animated: animated)
        executeWithCompletion(completion, animted: animated)
        return vcs
    }
}


extension _TetrisNamespaceWrapper where Subject : UIViewController {

    public func sendResp<T>(_ resp: T) {
//        if let vc = obj as? ViewIntent.IntentTargetType {
//            vc.getViewIntent()?.sendResp(resp, sender: self)
//        }
    }

    public func finishDisplay(animated: Bool = true, complete: IDisplayer.Completion? = nil) {
//        if let vc = obj as? ViewIntent.IntentTargetType {
//            vc.getViewIntent()?.displayer?.finishDisplay(vc, animated: animated, complete: complete)
//        }
    }

}






