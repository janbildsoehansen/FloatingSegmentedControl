//
//  Copyright © 2020 Dario Gonzalez.
//
//  Licensed under the MIT license. See the LICENSE file for more info.
//

import SwiftUI

/// A control for selecting from a set of mutually exclusive values.
public struct FloatingSegmentedControlView: View {
    @State private var widths: [CGFloat] = Array(repeating: 0, count: 100)
    @State private var selectedIndex: Int = 0
    @State private var buttomTapScale: CGFloat = 1
    
    var items: [String]
    var title: String
    var onSelected: (Int) -> ()
    
    public var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 7) {
                ForEach(self.items, id: \.self) { item in
                    ItemView(text: item)
                        .foregroundColor(self.selectedIndex == self.items.firstIndex(of: item)! ? .clear : .gray)
                }
            }
            .padding(.horizontal, 4.0)
            
            VStack(alignment: .underlineLeading) {
                Button(action: {
                    withAnimation(.easeIn(duration: 1)) {
                        self.buttomTapScale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeIn(duration: 1)) {
                          self.buttomTapScale = 1
                        }
                    }
                }) {
                    DividerView(buttomTapScale: $buttomTapScale)
                }
                .alignmentGuide(.underlineLeading) { d in d[.leading]  }
                .frame(width: widths[selectedIndex], height: 30)
                .animation(.spring())
                .offset(y: 19)
                
                HStack(alignment: .center, spacing: 7) {
                    ForEach(self.items, id: \.self) { item in
                        ItemView(text: item)
                            .foregroundColor(self.selectedIndex == self.items.firstIndex(of: item)! ? .white : .clear)
                            .modifier(WidthUpdater(selectedIndex: self.$selectedIndex, widths: self.$widths, onSelected: self.onSelected, id: self.items.firstIndex(of: item)!))
                            .background(TextGeometryWidth())
                            .onPreferenceChange(WidthPreferenceKey.self, perform: { self.widths[self.items.firstIndex(of: item)!] = $0 })
                    }
                }
                .offset(y: -18.5)
            }
            .frame(height: 30)
        }
        .padding(.vertical, 4.0)
        .background(BlurView(style: .systemMaterialLight))
        .cornerRadius(16)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("\(self.title)"))
        .accessibility(value: Text("\(self.items[self.selectedIndex])"))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if self.selectedIndex < self.items.count - 1 {
                    self.selectedIndex = self.selectedIndex + 1
                    self.onSelected(self.selectedIndex)
                }
                
            case .decrement:
                if self.selectedIndex > 0 {
                    self.selectedIndex = self.selectedIndex - 1
                    self.onSelected(self.selectedIndex)
                }
            @unknown default: ()
            }
        }
        .shadow(radius: 10)
    }
}

extension FloatingSegmentedControlView {

    /// Creates an instance that selects from `items` values.
    public init(
        _ items: [String],
        title: String,
        onSelected: @escaping (Int) -> ())
    {
        self.items = items
        self.title = title
        self.onSelected = onSelected
    }

}
