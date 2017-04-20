//
//  TreeProperties.swift
//  TreeView
//
//  Created by Swapnil Dhotre on 10/04/17.
//  Copyright © 2017 Swapnil Dhotre. All rights reserved.
//

import UIKit
import SwiftyJSON

/// TreeNode having data to load on tree root level should be 0 then goes according to depth
public class TreeNode: Equatable {
  var data: JSON?
  var isExpanded: Bool
  var isChecked: Bool = false
  var pageCount: Int
  
  var title: String
  private(set) var level: Int
  private(set) var id: String
  private(set) var parentId: String
  fileprivate(set) var childs: [TreeNode] = []
  fileprivate  var hidden: Bool
  fileprivate  var indentation: Int = 0
  fileprivate  weak var parent: TreeNode?
  
  
  init(id: String, level: Int, title: String, parentId: String, data: JSON?, isExpanded: Bool, pageCount: Int) {
    
    self.id = id
    self.parentId = parentId
    self.level = level
    self.title = title
    self.data = data
    self.isExpanded = isExpanded
    self.indentation = level
    self.hidden = false
    self.pageCount = pageCount
  }
  
  /// Check equality of objects
  ///
  /// - parameter lhs: first object as node
  /// - parameter rhs: second object as node
  ///
  /// - returns: return if match found
  public static func ==(lhs: TreeNode, rhs: TreeNode) -> Bool {
    
    return lhs.id == rhs.id
  }
  
}

class SDTreeViewCell: UITableViewCell {
  
  var btnArrowTapped: ((IndexPath) -> Void)?
  var btnCheckUncheckTapped: ((IndexPath) -> Void)?
  var indexPath: IndexPath?
}

public protocol SDTreeDataSource {
  
  func sdTreeViewData()
}

@objc protocol SDTreeDelegate: UITableViewDelegate {
  
  /// Passes current tableView instance, selected node and indexPath
  ///
  /// - parameter tableView: Instance of tableView
  /// - parameter treeNode:  selected node instance of TreeNode
  /// - parameter indexPath: indexPath of selected cell
  @objc optional func sdTableView(_ tableView: UITableView, selectedNode treeNode: Any, indexPath: IndexPath)
  
  @objc optional func sdCheckBox( indexPath: IndexPath )
}

public enum SearchBy {
  
  case startsWith
  case containsWith
}

public class SDTree: UITableView, UITableViewDataSource, UITableViewDelegate {
  
  var sdDelegate: SDTreeDelegate?
  
  //User Interation Properties
  var searchStringBy: SearchBy?
  var makeCellClickable: Bool = false
  var showCheckBox: Bool = false
  var indentSpacing: Int = 30
  
  //monitors when value change and act accordingly
  var searchForText: String = "" {
    
    didSet {
      
      self.searchFor(searchText: searchForText)
    }
  }
  
  private var isChildsSelected: Bool = false
  
  private var selectedNodeId: [String] = []
  private var selectedTag: [String] = []
  
  private var rowsToDisplay: [TreeNode] = []
  private var treeData: [TreeNode] = []
  private var tempData: [TreeNode] = []
  private var skipData: [TreeNode] = []
  private var nodesHidden: [TreeNode] = []
  
  //MARK: - SD TableViewData Source
  /// Loads raw data and convert it to child parent relationship
  ///
  /// - parameter data: raw data
  public func loadData( data: [TreeNode]) {
    
    rowsToDisplay = []
    treeData = []
    tempData = []
    skipData = []
    nodesHidden = []
    
    let nib = UINib(nibName: "TreeViewCell", bundle: nil)
    self.register(nib, forCellReuseIdentifier: "treeCell")
    
    //Keep data cached for future reference
    self.tempData = data
    
    //find max depth level
    let foundMaxLevel = data.map { $0.level }.max()
    guard let maxLevel = foundMaxLevel else {
      
      print("Maximum number not found")
      return
    }
    
    if maxLevel > 0 {
      
      //Filter items which has level 0
      let levelZeroFiltered = data.filter { $0.level == 0 }
      self.treeData = levelZeroFiltered
      
      //Iterate and get child nodes
      for obj in levelZeroFiltered {
        
        obj.parent = nil
        obj.childs = self.getChildNodes(node: obj, currentLevel: 0, maxLevel: maxLevel)
      }
    }
    
    //Set delegate and data source to self for events
    self.delegate = self
    self.dataSource = self
    
    self.rowsToDisplay = self.treeData
    
    self.printRecords(treeNodes: self.treeData)
    self.reloadData()
  }
  
  //MARK: - TreeView DataSource
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 50
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.rowsToDisplay.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.dequeueReusableCell(withIdentifier: "treeCell") as! TreeNodeTableViewCell
    
    let item: TreeNode = self.rowsToDisplay[indexPath.row]
    
    cell.labelTitle.text = item.title
    
    if item.childs.count > 0 {
      
      if item.isExpanded {
        
        cell.btnArrow.setImage(UIImage(named: "arrowDown"), for: .normal)
      } else {
        
        cell.btnArrow.setImage(UIImage(named: "arrowRight"), for: .normal)
      }
    } else {
      
      cell.btnArrow.setImage(UIImage(named: "dot"), for: .normal)
    }
    
    cell.indentationSpace.constant = CGFloat(item.indentation * self.indentSpacing)
    
    //If property checkbox is shown then show it
    if self.showCheckBox {
      
      if item.isChecked {
        
        cell.btnCheckUncheck.setImage(#imageLiteral(resourceName: "check"), for: .normal)
      } else {
        
        cell.btnCheckUncheck.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
      }
    } else {
      
      cell.btnCheckUncheck.isHidden = true
    }
    
    //Set indexPath to have track of indexpath
    cell.indexPath = indexPath
    cell.btnArrowTapped = { (indexPath) in
      
      self.cellSelection(withIndexPath: indexPath, calledByCell: false)
    }
    
    cell.btnCheckUncheckTapped = { (indexPath) in
      
      self.cellCheckBoxTapped(onIndexPath: indexPath)
    }
    
    return cell
  }
  
  //MARK: - TreeView Delegate methods
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if self.makeCellClickable {
      
      self.cellSelection(withIndexPath: indexPath, calledByCell: true)
    }
  }
  
  //MARK: - Custom Methods
  /// When checkbox is tapped in treeView it is called. If node is checked then check for siblings with that node is selected if true then auto select parent
  ///
  /// - parameter indexPath: IndexPath on which event has performed
  private func cellCheckBoxTapped(onIndexPath indexPath: IndexPath) {
    
    if self.rowsToDisplay[indexPath.row].isChecked {
      
      self.markUnchecked(forNode: self.rowsToDisplay[indexPath.row])
      self.markParentUnchecked(forNode: self.rowsToDisplay[indexPath.row])
    } else {
      
      self.markChecked(forNode: self.rowsToDisplay[indexPath.row])
      
      if let parent = self.rowsToDisplay[indexPath.row].parent {
        
        self.isChildsSelected = true
        if self.checkSelectedItem(treeNodes: parent.childs) {
          
          parent.isChecked = true
        }
      }
    }
    self.reloadData()
  }
  
  /// When cell is selected it is called. Here it is checked if any of the child node is present in it. This even return delegate to user controller. Data passed to it is nodes which is not actually seen on screen.
  ///
  /// - parameter indexPath: IndexPath on which event has performed
  private func cellSelection(withIndexPath indexPath: IndexPath, calledByCell: Bool) {
    
    let item: TreeNode = self.rowsToDisplay[indexPath.row]
    
    if calledByCell {
      
      //Send the click event back to user who tapped on it using delegate
      if let delegate = self.sdDelegate {
        
        let node = TreeNode(id: item.id, level: item.level, title: item.title, parentId: item.parentId, data: item.data, isExpanded: item.isExpanded, pageCount: item.pageCount)
        node.parent = item.parent
        node.childs = self.getDisplayableChildNodes(fromNode: item)
        delegate.sdTableView!(self, selectedNode: node, indexPath: indexPath)
      }
    }
    if item.childs.count > 0 {
      
      //Check if already expanded then remove nodes present below it
      if item.isExpanded {
        
        self.removeChilds(ofNode: item)
        
      } else {
        
        var indexPaths: [IndexPath] = []
        var objects: [TreeNode] = []
        for obj in item.childs {
          
          if !obj.hidden {
            
            objects.append(obj)
            indexPaths.append(IndexPath(row: indexPath.row + 1, section: 0))
          }
        }
        
        self.rowsToDisplay.insert(contentsOf: objects, at: indexPath.row + 1)
        
        //                self.beginUpdates()
        //                self.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        //                self.endUpdates()
        
      }
      
      //Toggle the expanded condition after update in array
      self.rowsToDisplay[indexPath.row].isExpanded = !self.rowsToDisplay[indexPath.row].isExpanded
      
      self.reloadData()
    }
  }
  
  /// Node which could be send back with delegate to user. We need to create new objects because tree searching is managed by hiding data not actually by removing data from root.
  ///
  /// - parameter treeNode: Node whose childs and subchilds needs to be given back.
  ///
  /// - returns: return array of node found
  private func getDisplayableChildNodes(fromNode treeNode: TreeNode) -> [TreeNode] {
    
    var nodes: [TreeNode] = []
    for obj in treeNode.childs {
      
      if !obj.hidden {
        
        let node = TreeNode(id: obj.id, level: obj.level, title: obj.title, parentId: obj.parentId, data: obj.data, isExpanded: obj.isExpanded, pageCount: obj.pageCount)
        node.parent = obj.parent
        node.childs.append(contentsOf: self.getDisplayableChildNodes(fromNode: obj))
        nodes.append(node)
      }
    }
    
    return nodes
  }
  
  /// Reseting nodes hidden property. So that fresh operation could start on data
  ///
  /// - parameter treeNodes: Reset data below nodes
  private func resetNodes(treeNodes: [TreeNode]) {
    
    printRecords(treeNodes: treeNodes)
    for node in treeNodes {
      
      if node.parent == nil && self.searchForText != "" {
        
        node.hidden = true
      } else {
        
        node.hidden = false
      }
      self.resetNodes( treeNodes: node.childs)
    }
    
  }
  
  /// Visible node means an array which maintains node differently just for visibility sake. So here items which resets because of search are going to set for visibility. Such as if node is expanded and not hidden then we need to show or add to visibility array.
  ///
  /// - parameter treeNodes: node under whose item need to reset
  private func resetVisibleNodes(treeNodes: [TreeNode]) {
    
    for node in treeNodes {
      
      //Check if item is expanded and not hidden
      if node.isExpanded && !node.hidden {
        
        self.rowsToDisplay.append(node)
        self.resetVisibleNodes(treeNodes: node.childs)
        
      } else if !node.hidden { // Here node is not expanded because it doesnt have child but found in searched category
        
        self.rowsToDisplay.append(node)
      }
    }
    
  }
  
  /// Recursively Iterate until root node doesn't found. There can be multiple items and there relationship need to maintain. Here in this block 2 class arrays are used to identify relation when multiple items found.
  ///
  /// - parameter values: values are the items found while searching
  private func setNodesToParent(values: [TreeNode]) {
    
    //Iterate in items found
    for obj in values {
      
      if (obj.parent == nil) {
        
        obj.hidden = false
      }
      
      //Get parent item if exist
      if let parent = obj.parent {
        
        //Filter and loop in the items which do not match with searched by id.
        for childObj in parent.childs.filter({ $0.id != obj.id }) {
          
          //Check if child which is going to hide(because it does not match to searched node) is already found in other node's searched category
          if !self.skipData.contains( { childObj }()) {
            
            childObj.hidden = true
            //Node going to add here whose child or subchilds is hidden
            self.nodesHidden.append(childObj)
          }
          
        }
        
        //Filter in hidden node to find if the node is hidden but now needs to show
        let nodeFoundHidden = self.nodesHidden.filter({ $0.id == obj.id })
        if nodeFoundHidden.count > 0 {
          
          nodeFoundHidden[0].hidden = false
        }
        
        //Those nodes are going to add here whose child or sub child is being searched
        self.skipData.append(contentsOf: parent.childs.filter({ $0.id == obj.id }))
        
        //Call again to iterate till parent found empty
        self.setNodesToParent(values: [parent])
      }
    }
  }
  
  /// Search for the text in tree
  ///
  /// - parameter searchText: search text parameter
  private func searchFor(searchText: String) {
    
    //If searchText is empty then show all the rows again
    if searchText == "" {
      
      self.resetNodes(treeNodes: self.treeData)
      self.rowsToDisplay = []
      self.resetVisibleNodes(treeNodes: self.treeData)
      self.reloadData()
      return
    }
    
    //Filter by contains in string which is done by case insensitive
    var values: [TreeNode] = []
    
    if let searchBy = self.searchStringBy {
      
      if searchBy == SearchBy.containsWith {
        
        values = self.tempData.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        
      } else if searchBy == SearchBy.startsWith {
        
        values = self.tempData.filter { $0.title.lowercased().hasPrefix(searchText.lowercased()) }
      }
    } else {
      
      values = self.tempData.filter { $0.title.lowercased().hasPrefix(searchText.lowercased()) }
    }
    
    //Empty arrays which manages search items
    self.skipData = []
    self.nodesHidden = []
    
    //Reset nodes hidden state
    self.resetNodes(treeNodes: self.treeData)
    
    //Set nodes to extreme parent node
    self.setNodesToParent(values: values)
    
    //searched item is raw data so need to set according to visibility
    self.rowsToDisplay = []
    self.resetVisibleNodes(treeNodes: self.treeData)
    
    //Reload tableview
    self.reloadData()
  }
  
  /// Remvove childs from the array rows which are being displayed on screen
  ///
  /// - parameter node: Node for which child nodes to be removed
  private func removeChilds(ofNode node: TreeNode) {
    
    //Filter by parentId present in child nodes
    let foundChilds = self.rowsToDisplay.filter { $0.parentId == node.id }
    for obj in foundChilds {
      
      //Set property expandable to false so that it will not show Icon opened after shown again
      obj.isExpanded = false
      
      //Iterate recursively to remove objects from array
      if obj.childs.count > 0 {
        
        self.removeChilds(ofNode: obj)
      }
      
      self.rowsToDisplay.removeObject(object: obj)
    }
  }
  
  /// Get child node of the provided node with current iteration level and max depth level
  ///
  /// - parameter node:         TreeNode of whose childs nodes need to retrive and ofcourse there childs also
  /// - parameter currentLevel: Current level in which it is iterating
  /// - parameter maxLevel:     MaxLevel is the depth of the tree
  ///
  /// - returns: Array of child nodes of the given node
  private func getChildNodes( node: TreeNode, currentLevel: Int, maxLevel: Int ) -> [TreeNode] {
    
    //Filter by parent id present in childs nodes and id of current node
    let filteredByParentId = self.tempData.filter { $0.parentId == node.id }
    let level = currentLevel + 1
    
    //Iterate in nodes and set parent object
    for obj in filteredByParentId {
      
      obj.parent = node
      
      //Check if level has crossed max level and then return back else recursively call the same method until match to depth
      if level <= maxLevel {
        
        obj.childs = self.getChildNodes(node: obj, currentLevel: level, maxLevel: maxLevel)
      }
    }
    
    return filteredByParentId
  }
  
  /// Iterate to parent to uncheck if any parent has checked and after that any of the child is unchecked
  ///
  /// - parameter treeNode: treeNode whose parent need to uncheck
  private func markParentUnchecked(forNode treeNode: TreeNode) {
    
    treeNode.isChecked = false
    if let node = treeNode.parent {
      
      self.markParentUnchecked(forNode: node)
    }
  }
  
  /// Mark UnCheck box and its sub childs if exist
  ///
  /// - parameter treeNode: node under whose child needs to unchecked
  private func markUnchecked(forNode treeNode: TreeNode) {
    
    treeNode.isChecked = false
    for node in treeNode.childs {
      
      self.markUnchecked(forNode: node)
    }
  }
  
  /// Mark Check box and its sub childs if exist
  ///
  /// - parameter treeNode: node under whose child needs to checked
  private func markChecked(forNode treeNode: TreeNode) {
    
    treeNode.isChecked = true
    for node in treeNode.childs {
      
      self.markChecked(forNode: node)
    }
  }
  
  private func printRecords(treeNodes: [TreeNode]) {
    
    for node in treeNodes {
      
      //            print("Node: \(node.title), id: \(node.id), hidden: \(node.hidden), exppanded:\(node.isExpanded), parentId: \(node.parentId), ParentObject: \(node.parent?.id)")
      
      self.printRecords(treeNodes: node.childs)
    }
  }
  
  /// Get selected node id
  ///
  /// - returns: returns id of selected nodes
  public func getSelectedId() -> [String] {
    
    self.selectedNodeId = []
    self.getSelectedId(forNodes: self.treeData)
    
    return self.selectedNodeId
  }
  
  /// Get nodes which is being selected in tree view. Reused existing skipData array for manipulation
  ///
  /// - returns: return array of nodes
  public func getSelectedNode() -> [TreeNode] {
    
    self.skipData = []
    self.getSelectedNode(forNodes: self.treeData)
    
    return self.skipData
  }
  
  /// Tag name of selected items. But if every child in parent is selected then only parent tag is returned. And if invidual child if selected all will return with there tags
  ///
  /// - returns: Array of tag
  public func getSelectedTagName() -> [String] {
    
    self.selectedTag = []
    self.getSelectedTag(treeNodes: self.treeData)
    
    return self.selectedTag
  }
  
  /// Get selected nodes iterating to every child in it
  ///
  /// - parameter treeNodes: nodes in which you need to traverse
  private func getSelectedNode(forNodes treeNodes: [TreeNode]) {
    
    for node in treeNodes {
      
      if node.isChecked {
        
        self.skipData.append(node)
      }
      self.getSelectedNode(forNodes: node.childs)
    }
    
  }
  
  /// Get all selected nodeid back
  ///
  /// - parameter treeNodes: nodes in which app need to traverse
  private func getSelectedId(forNodes treeNodes: [TreeNode]) {
    
    for node in treeNodes {
      
      if node.isChecked {
        
        self.selectedNodeId.append(node.id)
      }
      self.getSelectedId(forNodes: node.childs)
    }
  }
  
  /// It helps to fetch tag that has been selected. It works such as when a parent is selected with its all childs then only parent tag is appended in returning array
  ///
  /// - parameter treeNodes: nodes in which you are traversing
  ///
  /// - returns: return true if match found. Basically it is set when called this method and set false when any of the item is not selected
  private func checkSelectedItem(treeNodes: [TreeNode]) -> Bool {
    
    for node in treeNodes {
      
      if !node.isChecked {
        
        self.isChildsSelected = false
        break;
      }
      
      _ = self.checkSelectedItem(treeNodes: node.childs)
    }
    
    return self.isChildsSelected
  }
  
  /// Here only the parent tag is selected in which whole childs are being selected
  ///
  /// - parameter treeNodes: treeNode is Parameter in which currently being traversed
  private func getSelectedTag(treeNodes: [TreeNode]) {
    
    for node in treeNodes {
      
      if node.isChecked {
        
        self.isChildsSelected = true
        if self.checkSelectedItem(treeNodes: node.childs) {
          
          self.selectedTag.append(node.title)
          continue
        }
      }
      self.getSelectedTag(treeNodes: node.childs)
    }
  }
}

