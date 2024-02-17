//
//  ListView.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI

struct ListView: View {

    @Environment(\.safeAreaInsets) var safeAreaInsets

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Today")
                    .font(Font.custom("OpenRunde-Regular", size: 14))
                    .foregroundStyle(.secondary)

                ForEach(0..<3, id: \.self) { _ in
                    HStack(spacing: 13) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.quaternarySystemFill))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .stroke(.borderBackground, lineWidth: 1)
                            )
                            .frame(width: 39, height: 39)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("SampleNote.pdf")
                                .font(Font.custom("OpenRunde-Medium", size: 15))
                        }

                        Spacer()
                    }
                }

                Bar()

                Text("Yesterday")
                    .font(Font.custom("OpenRunde-Regular", size: 14))
                    .foregroundStyle(.secondary)

                ForEach(0..<5, id: \.self) { _ in
                    HStack(spacing: 13) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.quaternarySystemFill))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .stroke(.borderBackground, lineWidth: 1)
                            )
                            .frame(width: 39, height: 39)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("SampleNote.pdf")
                                .font(Font.custom("OpenRunde-Medium", size: 15))
                        }

                        Spacer()
                    }
                }

                Bar()

                Text("3 days ago")
                    .font(Font.custom("OpenRunde-Regular", size: 14))
                    .foregroundStyle(.secondary)

                ForEach(0..<5, id: \.self) { _ in
                    HStack(spacing: 13) {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.quaternarySystemFill))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .stroke(.borderBackground, lineWidth: 1)
                            )
                            .frame(width: 39, height: 39)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("SampleNote.pdf")
                                .font(Font.custom("OpenRunde-Medium", size: 15))
                        }

                        Spacer()
                    }
                }
            }
            .padding()
            .padding(.top, safeAreaInsets.top + 60)
            .padding(.bottom)
        }
        .safeAreaPadding(.bottom, 120)
        .overlay(
            SafeAreaBlockTop()
            , alignment: .top
        )
        .overlay(
            HStack(spacing: 5) {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline.weight(.medium))

                Text("Search")
                    .font(Font.custom("OpenRunde-Regular", size: 16))

                Spacer()
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 9)
            .foregroundStyle(.secondary)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            .padding()
            .padding(.top, safeAreaInsets.top)
            , alignment: .top
        )
    }
}
