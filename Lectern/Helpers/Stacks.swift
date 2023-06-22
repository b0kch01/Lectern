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

struct TrailingHStack <Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

            content
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
