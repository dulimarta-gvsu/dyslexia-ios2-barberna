import SwiftUI

struct LetterGroup: View {
    @Binding var letters: [Letter]
    var onRearrangeLetters: ([Letter]) -> Void
    var backgroundColor: Color
    var isSolved: Bool
    
    init(letters: Binding<[Letter]>,
         backgroundColor: Color,
         isSolved: Bool,
         onRearrangeLetters: @escaping ([Letter]) -> Void) {
        self._letters = letters
        self.backgroundColor = backgroundColor
        self.isSolved = isSolved
        self.onRearrangeLetters = onRearrangeLetters
    }
    
    @State var boxSize = CGSize.zero
    @State var startCellIndex: Int? = nil
    @State var blankCellIndex: Int? = nil
    @State var pointerIndex: Float? = nil
    @State var dragOffset = CGPoint.zero
    @State var draggedLetter: Letter? = nil
    @State var startPointerPosition = CGPoint.zero
    @GestureState var what = false

    var body: some View {
        ZStack {
            let letterSize = min(80, (UIScreen.main.bounds.width - 32) / CGFloat(max(letters.count, 1)))
            // The extra BigLetter position aligns with the center
            // of the HStack. So the dragoffset must be adjusted by
            // the relative position of the starting drag point w.r.t
            // to the HStack center
            if let draggedLetter {
                BigLetter(letter: draggedLetter, size: letterSize, backgroundColor: backgroundColor)
                    .zIndex(10)
                    .offset(x: dragOffset.x + startPointerPosition.x - boxSize.width / 2, y: dragOffset.y)
            }

            VStack {
                HStack(spacing: 2) {
                    ForEach(Array(self.letters.enumerated()), id: \.offset) { pos, letter in
                        BigLetter(letter: letter, size: letterSize, backgroundColor: backgroundColor)
                    }
                }
                .onGeometryChange(for: CGSize.self, of: { $0.size as CGSize }, action: { boxSize = $0 })
                .gesture(
                    isSolved ? nil : DragGesture()
                    .onChanged { drag in
                        guard letters.count > 0 else { return }
                        
                        let percentage = drag.location.x / boxSize.width
                        var index = percentage * CGFloat(letters.count)
                        startPointerPosition = drag.startLocation
                        
                        if index < 0 { index = 0 }
                        else if index > CGFloat(letters.count - 1) { index = CGFloat(letters.count - 1) }
                        
                        if draggedLetter == nil {
                            blankCellIndex = Int(index)
                            startCellIndex = Int(index)
                            draggedLetter = letters[blankCellIndex!]
                            letters[blankCellIndex!] = Letter()
                        }
                        
                        if blankCellIndex != Int(index) {
                            letters[blankCellIndex!] = letters[Int(index)]
                            letters[Int(index)] = Letter()
                            blankCellIndex = Int(index)
                        }
                        
                        pointerIndex = Float(index)
                        dragOffset = CGPoint(x: drag.location.x - drag.startLocation.x,
                                             y: drag.location.y - drag.startLocation.y)
                    }
                    .onEnded { _ in
                        guard let blankIndex = blankCellIndex, let dragged = draggedLetter else {
                            resetLocalState()
                            return
                        }
                        
                       
                        let actuallyMoved = (blankIndex != startCellIndex)
                        
                        letters[blankIndex] = dragged
                        
                        let finalState = letters
                        resetLocalState()
                        
                        if actuallyMoved {
                            self.onRearrangeLetters(finalState)
                        }
                    }
                )
            }
        }
    }
    
    // Helper to clear variables
    private func resetLocalState() {
        draggedLetter = nil
        pointerIndex = nil
        startCellIndex = nil
        blankCellIndex = nil
        startPointerPosition = .zero
        dragOffset = .zero
    }
}

struct BigLetter: View {
    private let ch: String
    private let pt: Int
    let size: CGFloat
    let backgroundColor: Color
    init(letter: Letter, size: CGFloat = 44, backgroundColor: Color = .mint) {
        self.ch = String(letter.text)
        self.pt = letter.point
        self.size = size
        self.backgroundColor = backgroundColor
    }
    var body: some View {
        ZStack{
            Text(self.ch)
                .font(Font.system(size: 0.8 * self.size, weight: .bold))
        }
        .frame(width: self.size, height: self.size)
        .background(self.pt == 0 ? .clear : backgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
        )
    }
}
