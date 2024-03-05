//
//  BookmarkDB.swift
//  
//
//  Created by Steven Hertz on 3/5/24.
//

import Foundation
import SQLite
class BookmarkDB
{
    static let shared = BookmarkDB()
    
    //-- Bookmark Table
    let bookmarks = Table("bookmarks")
    
    
    let id = Expression<Int64>("ID")
    let shiurID = Expression<Int>("shiurID")
    let title = Expression<String>("title")
    let progress = Expression<Double>("progress")
    let time = Expression<Int>("time")
    
    func initBookmarkTable()
    {
        self.bookmarkCreateTable { (success) in }
    }
    
    //-- Create Table
    func bookmarkCreateTable(completionHandler : @escaping( Bool?) -> Void)
    {
        do
        {
            try DBHelper.shared.connectDB().run(bookmarks.create { t in
                t.column(id, primaryKey: true)
                t.column(shiurID)
                t.column(title)
                t.column(progress)
                t.column(time)
            })
            completionHandler(true)
        } catch {
            print("Bookmark table creation error")
            completionHandler(false)
        }
    }
    
    //-- Insert values into table
    func bookmarkInsert(valueDict: NSDictionary, completionHandler : @escaping( Bool?) -> Void)
    {
        do
        {

            try DBHelper.shared.connectDB().run(bookmarks.insert(
                shiurID <- (valueDict.object(forKey: "shiurID") as? Int ?? 0),
                title <- (valueDict.object(forKey: "title") as? String ?? ""),
                time <- (valueDict.object(forKey:  "time") as? Int ?? 0),
                progress <- (valueDict.object(forKey: "progress") as? Double ?? 0)
            ))
            completionHandler(true)
        }
        catch
        {
            print("Error to insert bookmark table")
        }
    }
    
    func getAllBookmarks(completionHandler : @escaping([Bookmark]) -> Void) {
        var bookmarkItems: [Bookmark] = []
        
        do {
            for bookmark in try DBHelper.shared.connectDB().prepare(bookmarks) {
                try bookmarkItems.append(Bookmark.init(id: Int(bookmark.get(id)),
                                                       shiurID: bookmark.get(shiurID),
                                                       title: bookmark.get(title),
                                                       progress: bookmark.get(progress),
                                                       time: bookmark.get(time)))
            }
            completionHandler(bookmarkItems)
        }
        catch{
            completionHandler(bookmarkItems)
        }
    }
    
    
    //-- Delete row from table
    func deleteBookmark(forID : Int64)
    {
        let query = bookmarks.filter(id == forID)
        
        do {
            if try DBHelper.shared.connectDB().run(query.delete()) > 0 {
                print("row deleted")
            } else {
                print("row not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
}
