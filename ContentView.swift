//
//  ContentView.swift
//  LoraExplorer
//
//  Created by Neal Katz on 10/2/24.
//

import SwiftUI
import SwiftData
import os.log
import SwiftyJSON

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var droppedFilePath = ""
    @State private var canPop = true
    @State private var presentAbout = false
    @State private var errorFlag = false
    @State private var detailsText = "No Details"
    @State private var detailsjson =  JSON()
    @State private var lastFilePath = ""  // the last file that was detected as being new, used for deduping
    var body: some View {
        NavigationSplitView {
            Text(droppedFilePath)
            /*List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }*/
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    /*
                     Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                     */
                }
            }
        } detail: {
            detailView()
        }
    }
    @ViewBuilder func detailView()  -> some View  {
         ZStack {
             VStack(alignment: .leading) {
                 HStack(alignment: .center) {
                     ScrollView {
                         if errorFlag {
                             Text(detailsText).textSelection(.enabled)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                                 .padding(.leading, 8).font(.title2)
                         } else {
                             if let modelspec_title = detailsjson["modelspec.title"].string{
                                 Text("Lora Title : \(modelspec_title)").textSelection(.enabled)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .padding(.leading, 8).font(.title3)
                             }
                             if let ss_output_name = detailsjson["ss_output_name"].string{
                                 Text("Lora Name : \(ss_output_name)").textSelection(.enabled)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .padding(.leading, 8).font(.title3)
                             }
                             if let ss_base_model_version = detailsjson["ss_base_model_version"].string{
                                 Text("Base Model : \(ss_base_model_version)").textSelection(.enabled)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .padding(.leading, 8).font(.title3)
                             } else {
                                 if let ss_sd_model_name = detailsjson["ss_sd_model_name"].string{
                                     Text("Base Model : \(ss_sd_model_name)").textSelection(.enabled)
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .padding(.leading, 8).font(.title3)
                                 }
                             }
                             
                             if let ss_training_comment = detailsjson["ss_training_comment"].string , ss_training_comment.caseInsensitiveCompare("None") != .orderedSame {
                                 Text("Comment : \(ss_training_comment)").textSelection(.enabled)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .padding(.leading, 8).font(.title3)
                             }
                             
                             Text(detailsText).textSelection(.enabled)
                         }
                     }
                 } .frame(maxWidth: .infinity,maxHeight: .infinity)
                 Divider()
                 HStack(alignment: .center) {
                     Text("Drop Safetensor file Here")
                         .padding()
                         .foregroundColor(.white)
                         .background(Color.blue)
                 }
                 .frame(height: 60)
                 .frame(maxWidth: .infinity)
                 .background(Color.blue.opacity(0.3)) // Added for visibility
             }
        }
         .onReceive(NotificationCenter.default.publisher(for: .presentAbout)) { _ in
             presentAbout = true
         }
         .sheet(isPresented: $presentAbout, content: {   AboutView()  })
         .onReceive(timerPollStack, perform: { _ in
             timerStuff()
         })
        .onDrop(of: ["public.file-url"], isTargeted: nil) { providers -> Bool in
            DispatchQueue.main.async {
                self.detailsjson = JSON()
                self.detailsText = "Loading..."
            }
            for provider in providers {
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
                    if let data = item as? Data, let fileURL = URL(dataRepresentation: data, relativeTo: nil) {
                        DispatchQueue.main.async {
                            os.Logger.main.info("\(#file):\(#function)  pushing \(fileURL.path) ")
                            self.droppedFilePath = fileURL.path
                            self.droppedFilePath = fileURL.path
                            pathsToScan.push(fileURL.path)
                        }
                    }
                }
            }
            return true
        }
    }
    func timerStuff() {
        if canPop , let path = pathsToScan.pop() {
            os.Logger.main.info("\(#file):\(#function)  popped \(path) ")
            canPop = false
            defer {
                canPop = true
            }
            if let json = SafeTensorMetadata.readMetadata(from: path),json.count > 0 {
                print("Metadata:")
                for (key, value) in json {
                    print("\(key): \(value)")
                }
                // .rawString() returns "null" on error
                if let md = json["__metadata__"].rawString(), md != "null"{
                    DispatchQueue.main.async {
                        self.errorFlag = false
                        self.detailsText = md
                        self.detailsjson = json["__metadata__"]
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorFlag = true
                        self.detailsText = "Could not find metadata in file"
                        self.detailsjson = JSON()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorFlag = true
                    self.detailsText = "Could not find metadata in file. Is this a safetensor file?"
                    self.detailsjson = JSON()
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
