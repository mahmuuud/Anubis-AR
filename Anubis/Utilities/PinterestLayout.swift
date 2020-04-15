import UIKit

protocol PinterestLayoutDelegate: AnyObject {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  
  weak var delegate: PinterestLayoutDelegate?
  private var cellPadding: CGFloat = 10
  private var numberOfColumns = 2
   var cache: [UICollectionViewLayoutAttributes] = []
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  override var collectionViewContentSize: CGSize {
    return CGSize(width: self.contentWidth, height: self.contentHeight)
  }
  
  override func prepare() {
    guard cache.isEmpty, let collectionView = collectionView else {
      return
    }
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffsets: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffsets.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffsets: [CGFloat] = .init(repeating: 40, count: numberOfColumns) //top insets
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = 2 * cellPadding + photoHeight
      let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attribute.frame = insetFrame
      cache.append(attribute)
      yOffsets[column] += height
      contentHeight = max(contentHeight, frame.maxY)
      column = column < numberOfColumns - 1 ? column + 1 : 0
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  
}
