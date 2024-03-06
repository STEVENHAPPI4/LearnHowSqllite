    //
    //  ContentView.swift
    //  LearnHowSqllite
    //
    //  Created by Steven Hertz on 3/5/24.
    //

import SwiftUI

struct ContentView: View {
    
    @State var bookmarks = [Bookmark]()
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}

extension ContentView {
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Button(action: {
                print("Init DB was tapped")
                DBHelper.shared.initDatabase() } )
            { Text("Init DB") }
                .padding()
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.blue)
                        .shadow(color: .black, radius: 2, x: 6, y: 6)
                }
                .padding()
            
            
            Button(action: {
                print("Insert Row was tapped")
                addBookmark() } )
            { Text("Insert Row") }
                .padding()
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.orange)
                        .shadow(color: .black, radius: 2, x: 6, y: 6)
                }
                .padding()
            
            
            Button(action: {
                print("get Rows was tapped")
                getBookMarks()} )
            { Text("Get Rows") }
                .padding()
                .foregroundStyle(.white)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.orange)
                        .shadow(color: .black, radius: 2, x: 6, y: 6)
                }
                .padding()
            
            
            getLazyVGridView(bookmarks: bookmarks)
            
            getListView(bookmarks: bookmarks)
            
        }
        .padding()
    }
}


extension ContentView {
    
    func getLazyVGridView(bookmarks: Array<Bookmark>) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(bookmarks) { bookmark in
                    VStack {
                        Text(bookmark.title).font(.headline)
                        Text("Progress: \(bookmark.progress * 100, specifier: "%.1f")%").font(.subheadline)
                        Text("Time: \(bookmark.time) seconds").font(.subheadline)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
    
    func getListView(bookmarks: Array<Bookmark>) -> some View {
        List(bookmarks) { bookmark in
            VStack(alignment: .leading) {
                Text(bookmark.title)
                    .font(.headline)
                Text("Progress: \(bookmark.progress * 100, specifier: "%.1f")%")
                    .font(.subheadline)
                Text("Time: \(bookmark.time) seconds")
                    .font(.subheadline)
            }
        }
    }
}

extension ContentView {
    
    
    func getBookMarks() {
        BookmarkDB.shared.getAllBookmarks{
            dbBookmarks in
            self.bookmarks = dbBookmarks
            dbBookmarks.forEach { bm in
                dump(bm)
            }
        }
    }
    
    func addBookmark() {
        let dataDict = ["shiurID" : Int.random(in: 1...100),
                        "title" : ["Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elxit", "sxed", "dxo", "eiusmod", "tempor", "incididunt", "ut"].randomElement() as Any,
                        "time": [20, 626, 11, 123, 432, 34, 64, 24, 92].randomElement() as Any,
                        "progress": 100] as [String : Any]
        
        BookmarkDB.shared.bookmarkInsert(valueDict: dataDict as NSDictionary ) { (isSuccess) in
            if (isSuccess)! {
                print("Great another recorf was inserted")
            }
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bookmarks: [
            Bookmark(id: 1, shiurID: 101, title: "Bookmark 1", progress: 0.5, time: 120),
            Bookmark(id: 2, shiurID: 102, title: "Bookmark 2", progress: 0.3, time: 150)
        ])
    }
}
