//
//  DMSLoginInfo.swift
//  DMS
//
//  Created by Scorg Technologies on 27/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import SwiftyJSON

class TreeViewLists {
    //MARK:  Load Array With Initial Data
    static var allTreeList: [TreeViewNode] = [TreeViewNode]()
    static var allTreeData: [(String, [String])] = [(String, [String])]()
    static var allTreeNodeId: [(String, Int)] = [(String, Int)]()
    static var dictAllTreeId: [(Int, [Int])] = [(Int, [Int])]()

    static func LoadInitialData(data : [JSON]) -> [TreeNode] {
        var fileDataArray = [TreeNode]()
        var parentId = Int()
        var parentName = String()
        var childId = Int()
        var childArray = [String]()
        var childIdArray = [Int]()
        for file in data {
            if let pId = file["categoryId"].int {
                parentId = pId
            }
            if let pName = file["categoryName"].string {
                
                fileDataArray.append(TreeNode(id: String(parentId), level: 0, title: pName, parentId: "", data: nil, isExpanded: false, pageCount: 0))
                parentName = pName
                allTreeNodeId.append((parentName, parentId))
            }
            if let childList = file["docTypeList"].array {
                for childName in childList {
                    if let cId = childName["typeId"].int {
                        childId = cId
                        childIdArray.append(cId)
                    }
                    if let cName = childName["typeName"].string {
                        
                        fileDataArray.append(TreeNode(id: String(childId), level: 1, title: cName, parentId: String(parentId), data: nil, isExpanded: false, pageCount: 0))
                        childArray.append(cName)
                        allTreeNodeId.append((cName, childId))
                    }
                }
                allTreeData.append((parentName, childArray))
                dictAllTreeId.append((parentId, childIdArray))
                childIdArray.removeAll()
                childArray.removeAll()
            }
        }
        return fileDataArray
    }
    
    //MARK:  Load Nodes From Initial Data
    
    static func LoadInitialNodes(dataList: [TreeViewData]) -> [TreeViewNode] {
        var nodes: [TreeViewNode] = []
        for data in dataList where data.level == 0 {
            //            print("Parent node \(data.name)")
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.name as AnyObject?
            node.isExpanded = Constants.FilterExpand.TRUE
            let newLevel = data.level + 1
            node.nodeChildren = LoadChildrenNodes(dataList: dataList, level: newLevel, parentId: data.id)
            if (node.nodeChildren?.count == 0) {
                node.nodeChildren = nil
            }
            nodes.append(node)
        }
        allTreeList = nodes
        return nodes
    }
    
    //MARK:  Recursive Method to Create the Children/Grandchildren....  node arrays
    
    static func LoadChildrenNodes(dataList: [TreeViewData], level: Int, parentId: String) -> [TreeViewNode] {
        var nodes: [TreeViewNode] = []
        for data in dataList where data.level == level && data.parentId == parentId {
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.name as AnyObject?
            node.isExpanded = Constants.FilterExpand.FALSE
            let newLevel = level + 1
            node.nodeChildren = LoadChildrenNodes(dataList: dataList, level: newLevel, parentId: data.id)
            if (node.nodeChildren?.count == 0) {
                node.nodeChildren = nil
            }
            nodes.append(node)
        }
        return nodes
    }
}
