//
//  LicensesView.swift
//  trendlines
//
//  Created by Grey Patterson on 4/15/21.
//

import SwiftUI

struct LicensesView: View {
    var body: some View {
        List {
            Section(header: Text("Trendlines")) {
                Text("This app is open source!")
                Link("View it on GitHub", destination: URL(string: "https://github.com/grey280/trendlines")!)
            }
            Section(header: Text("GRDB.swift")) {
                Text("Copyright (C) 2015-2020 Gwendal Roué\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.").font(.footnote)
                Link("GRDB.swift on GitHub", destination: URL(string: "https://github.com/groue/GRDB.swift")!)
            }
        }.navigationTitle("Licenses")
        .listStyle(InsetGroupedListStyle())
    }
}

struct LicensesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LicensesView()
        }
    }
}
