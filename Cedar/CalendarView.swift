import UIKit
import SwiftUI

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = UICollectionView
    
    func makeUIView(context: UIViewRepresentableContext<CalendarView>) -> CalendarView.UIViewType {
        let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return v
    }
    
    func updateUIView(_ uiView: CalendarView.UIViewType, context: UIViewRepresentableContext<CalendarView>) {
        
    }
}
