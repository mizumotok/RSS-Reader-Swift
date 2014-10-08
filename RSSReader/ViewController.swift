//
//  ViewController.swift
//  RSSReader
//
//  Created by Kiyoshi Mizumoto on 2014/09/27.
//  Copyright (c) 2014年 Andgenie Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate {

    let feedUrl : NSURL = NSURL(string: "http://rss.dailynews.yahoo.co.jp/fc/rss.xml")

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var tableView: UITableView!
    
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var parser : NSXMLParser = NSXMLParser(contentsOfURL: feedUrl)
        parser.delegate = self;
        parser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: item.url))
    }
    
    
    var currentElementName : String!
    
    let itemElementName = "item"
    let titleElementName = "title"
    let linkElementName   = "link"

    func parserDidStartDocument(parser: NSXMLParser!)
    {
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
    {
        currentElementName = nil
        if elementName == itemElementName {
            items.append(Item())
        } else {
            currentElementName = elementName
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        currentElementName = nil;
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        if items.count > 0 {
            var lastItem = items[items.count-1]
            if currentElementName? == titleElementName {
                var tmpString : String? = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string
            } else if currentElementName? == linkElementName {
                lastItem.url = string
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!)
    {
        self.tableView.reloadData()
    }
    
    class Item {
        var title : String!
        var url : String!
    }

}

