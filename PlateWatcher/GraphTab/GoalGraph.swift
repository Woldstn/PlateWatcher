//
//  GoalGraph_SUI.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/06/03.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct GraphDims {
    var width: CGFloat
    var height: CGFloat
    var leftBound: CGFloat
    var upperBound: CGFloat
    var rightBound: CGFloat
    var lowerBound: CGFloat
}

struct DataBar: View {
    let critPass: Bool
    
    var body: some View {
        Rectangle().opacity(0).background(background)
    }
    
    var background: some View {
        GeometryReader { geometry in
            Path { path in
                let height = geometry.size.height
                let width = geometry.size.width
                let cornerRadius = width * 0.25
                
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                path.addQuadCurve(
                    to: CGPoint(x: cornerRadius, y: 0),
                    control: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: width, y: cornerRadius),
                    control: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
            }.fill(self.gradient)
        }
    }
    
    var gradient: LinearGradient {
        get {
            let colors: [Color]
            if critPass {
                colors = [
                    Color(UIColor(red: 0, green: 0, blue: 1,    alpha: 1)),
                    Color(UIColor(red: 0, green: 0, blue: 0.75, alpha: 1))
                ]
            } else {
                colors = [
                    Color(UIColor(red: 1,    green: 0.5,   blue: 0, alpha: 1)),
                    Color(UIColor(red: 0.75, green: 0.375, blue: 0, alpha: 1))
                ]
            }
            return LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .bottomLeading,
                endPoint: .topTrailing)
        }
    }
}

struct GoalGraph: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var data: [Int]
    @State var showDataTooltip: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let graphDims = getGraphDims(geometry)
            
            ZStack {
                GraphBackground()
                YGuidelines(graphDims)
                GraphData(graphDims)
                if showDataTooltip {
                    VStack {
                        HStack {
                            DataTooltip()
                            Spacer()
                        }
                        Spacer()
                    }.padding(.all, 15)
                }
            }
        }
    }
    
    func GraphBackground() -> LinearGradient {
        let whiteVals: [CGFloat] = colorScheme == .dark ? [1, 0.8] : [0, 0.2]
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor(white: whiteVals[0], alpha: 1)),
                Color(UIColor(white: whiteVals[1], alpha: 1))
            ]), startPoint: .top, endPoint: .bottom)
    }
    
    func YGuidelines(_ graph: GraphDims) -> some View {
        var interval = 1
        var yVals: [Int] = []
        if let max = data.max(), let min = data.min() {
            if max > 50 {
                interval = 10
            } else if max > 20 {
                interval = 5
            } else if max > 10 {
                interval = 2
            }
            if max - min == 0 {
                yVals.append(contentsOf: [max + 1, max, max - 1])
            } else {
                var lineY = 0
                while lineY <= max {
                    yVals.append(lineY)
                    lineY += interval
                }
            }
            return Path { path in
                for val in yVals {
                    let ypos = graph.lowerBound - CGFloat(val) * graph.height / CGFloat(max)
                    path.move(to: CGPoint(x: graph.leftBound, y: ypos))
                    path.addLine(to: CGPoint(x: graph.rightBound, y: ypos))
                }
            }.stroke(Color.gray, lineWidth: 1)
        } else {
            return Path {_ in}.stroke(Color.gray, lineWidth: 1)
        }
    }
    
    @ViewBuilder
    func GraphData(_ graph: GraphDims) -> some View {
        let spaceWidth = graph.width / CGFloat(data.count * 4 + 1)
        let barWidth = spaceWidth * 3
        let ulPadding = graph.upperBound
        let lrPadding = graph.leftBound
        if let max = data.max() {
            let unitHeight = graph.height / CGFloat(max)
            HStack(alignment: .bottom) {
                Spacer()
                ForEach(data, id: \.self) { val in
                    DataBar(critPass: true)
                        .frame(width: barWidth, height: CGFloat(val) * unitHeight)
                    Spacer()
                }
            }.padding(EdgeInsets(
                        top: ulPadding,
                        leading: lrPadding,
                        bottom: ulPadding,
                        trailing: lrPadding))
        } else {
            EmptyView()
        }
    }
    
    func DataTooltip() -> some View {
        return VStack(alignment: .leading) {
            Text("日付: 5月24日")
            Text("食数: 5")
            Text("ゴール: ≧6")
        }
        .padding(.all, 5)
        .background(Color(UIColor(red: 1, green: 0.9, blue: 0.8, alpha: 1)))
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.orange, lineWidth: 2))
    }
    
    func getGraphDims(_ geometry: GeometryProxy) -> GraphDims {
        return GraphDims(
            width:      geometry.size.width  * 0.9,
            height:     geometry.size.height * 0.9,
            leftBound:  geometry.size.width  * 0.05,
            upperBound: geometry.size.height * 0.05,
            rightBound: geometry.size.width  * 0.95,
            lowerBound: geometry.size.height * 0.95)
    }
}

struct GoalGraph_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) { scheme in
            VStack {
                GoalGraph(data: [5, 8, 3, 5, 6, 7, 10])
                    .aspectRatio(1.2, contentMode: .fit)
                    .cornerRadius(10)
                    .padding(10)
                    .preferredColorScheme(scheme)
                Spacer()
            }
        }
    }
}

