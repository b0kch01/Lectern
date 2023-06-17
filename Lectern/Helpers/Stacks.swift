//
//  Stacks.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI

struct CenterStack <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 0) {
                Spacer()

                content

                Spacer()
            }

            Spacer()
        }
    }
}

struct LeadingHStack <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            content

            Spacer()
        }
    }
}

struct CenterVStack <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()

            content

            Spacer()
        }
    }
}

struct CenterHStack <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            content

            Spacer()
        }
    }
}

struct FlowStack<B, T: Hashable, V: View>: View {

    let mode: Mode

    @Binding var binding: B

    let items: [T]
    let viewMapping: (T) -> V

    @State private var totalHeight: CGFloat

    init(mode: Mode, binding: Binding<B>, items: [T], viewMapping: @escaping (T) -> V) {
        self.mode = mode
        _binding = binding
        self.items = items
        self.viewMapping = viewMapping
        _totalHeight = State(initialValue: (mode == .scrollable) ? .zero : .infinity)
    }

    var body: some View {
        let stack = VStack {
            GeometryReader { geometry in
                content(in: geometry)
            }
        }

        return Group {
            if mode == .scrollable {
                stack.frame(height: totalHeight)
            } else {
                stack.frame(maxHeight: totalHeight)
            }
        }
    }

    private func content(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                viewMapping(item)
                    .padding(9)
                    .alignmentGuide(.leading, computeValue: { dim in
                        if abs(width - dim.width) > g.size.width {
                            width = 0
                            height -= dim.height
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= dim.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geo -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.frame(in: .local).size.height
            }
            return .clear
        }
    }

    enum Mode {
        case scrollable, vstack
    }
}
