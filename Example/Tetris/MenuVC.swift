//
//  ViewController.swift
//  Tetris
//
//  Created by scubers on 04/28/2018.
//  Copyright (c) 2018 scubers. All rights reserved.
//

import UIKit
import Tetris

class MenuVC: BaseVC, URLRoutable, IComponent {

    var data = [
        ("1. Just Route!!", {return Intent.pushPop(url: "/demo/1")}),
        ("2. Parameters", {return Intent.pushPop(url: "/demo/2?a=a&b=b")}),
        ("3. Final intercepter", {return Intent.pushPop(url: "/demo/3")}),
        ("4. Global lost", {return Intent.pushPop(url: "/sdf/sdfoihg/sdkgjlj")}),
    ]

    var tableView: UITableView!

    class var routableURL: URLPresentable {return "/demo/menu"}

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height), style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MenuVC : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1")
        cell?.textLabel?.text = data[indexPath.row].0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let intent = data[indexPath.row].1()
        Tetris.getRouter().start(intent, source: self, completion: {
            print("---finish route---")
        }) { (result) in
            switch result.status {
            case .passed:print("passed")
            case .switched: print("switched")
            case .rejected: print("rejected: \(String(describing: result.errorInfo))")
            case .lost:print("lost")
            }
        }
    }
}

