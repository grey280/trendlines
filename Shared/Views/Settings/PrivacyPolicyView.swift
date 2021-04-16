//
//  PrivacyPolicyView.swift
//  trendlines
//
//  Created by Grey Patterson on 4/15/21.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Data Belongs To You").font(.title)
                Text("Any data you put into the app lives on your device, and never gets uploaded anywhere.").font(.title2)
                Text("If you give us access to your health data, we only use it to display your charts to you, on your device, and that data never gets uploaded anywhere, either.").font(.title2)
                Text("Here's the fine print:")
                Text("If you enabled 'Share Data with Developers' when you set up your iPhone, Apple gives us a little bit of anonymized data:")
                Group {
                    Text("We get told that ") + Text("someone").italic() + Text(" installed the app.")
                    Text("If the app crashes, we get an anonymized crash report to help us track down the problem, but none of your data is included.")
                }.padding(.leading)
                Text("Beyond that, we use a third party, RevenueCat, to handle the 'Pro' subscription.")
                Group {
                    Text("If you subscribe, they gather a little bit of information - just enough to know that you subscribed, and let us know, so we can unlock the features you paid for.")
//                    Text("You can view their privacy policy on ") + Link("their website.", destination: URL(string: "https://www.revenuecat.com/privacy")!)
                    (Text("You can view their privacy policy ") + Text("on their website.").underline().foregroundColor(.blue)).onTapGesture {
                        openURL(URL(string: "https://www.revenuecat.com/privacy")!)
                    }
                }.padding(.leading)
                
            }.padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPolicyView()
        }
    }
}
