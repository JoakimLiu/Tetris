import XCTest
@testable import Tetris

extension String {
    func toCharacterArray() -> [String] {
        return self.map {c in String(c)}
    }
}

class Tests: XCTestCase {

    var tree: Tree!

    var nodepathes = [
        NodePath.init(path: "1234".map({c in String(c)}), value: 1),
        NodePath.init(path: "123".map({c in String(c)}), value: 2),
        NodePath.init(path: "abcd".map({c in String(c)}), value: 3),
        NodePath.init(path: "abcdef".map({c in String(c)}), value: 4),
        NodePath.init(path: ["x", ":y", ":z"], value: 7),
    ]

    override func setUp() {
        super.setUp()
        tree = Tree()
        nodepathes.forEach({np in tree.buildTree(nodePath: np)});
        print(tree)
    }


    func testAdd() {
        let addArr = [
            NodePath.init(path: "abcde".toCharacterArray(), value: 5),
            NodePath.init(path: "12345".toCharacterArray(), value: 6),
        ]

        addArr.forEach({np in tree.buildTree(nodePath: np)})
        print(tree)

        var result = tree.findNode(by: "abcde".toCharacterArray())
        assert(result!.1.getValue() == 5)

        result = tree.findNode(by: "12345".toCharacterArray())
        assert(result!.1.getValue() == 6)


    }

    func testRemove() {

        var result = tree.findNode(by: "1234".toCharacterArray())
        assert(result!.1.getValue() == 1)

        tree.removeNode(by: "1234".toCharacterArray())
        tree.removeNode(by: "123".toCharacterArray())
        tree.removeNode(by: "abcde".toCharacterArray())
        print(tree)

        result = tree.findNode(by: "1234".toCharacterArray())
        assert(result == nil)
    }

    func testFind() {
        // This is an example of a functional test case.
        var result = tree.findNode(by: "abcde".toCharacterArray())
        assert(result == nil)

        result = tree.findNode(by: "abc".toCharacterArray())
        assert(result == nil)

        result = tree.findNode(by: "abcd".toCharacterArray())
        assert(result!.1.getValue() == 3)

        result = tree.findNode(by: "abcdef".toCharacterArray())
        assert(result!.1.getValue() == 4)

        result = tree.findNode(by: "1234".toCharacterArray())
        assert(result!.1.getValue() == 1)

        result = tree.findNode(by: "123".toCharacterArray())
        assert(result!.1.getValue() == 2)

        result = tree.findNode(by: "xyz".toCharacterArray())
        assert(result!.0["y"] == "y")
        assert(result!.0["z"] == "z")

        result = tree.findNode(by: "x12".toCharacterArray())
        assert(result!.0["y"] == "1")
        assert(result!.0["z"] == "2")
    }
    
}
