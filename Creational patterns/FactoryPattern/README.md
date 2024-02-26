# Factory Pattern

Factory 패턴은 자주 변경되는 **객체 생성 부분을** 별도의 클래스(팩토리)에게 위임하는 것을 말합니다. 이는 곧 자주 변경되는 곳의 캡슐화를 의미하기도 합니다.
정말 쉽게 설명하자면 그냥 if else 나 switch 처럼 분기처리 되는 부분을 통해서 어떤 객체를 생성하는 로직을 그냥 클래스나 구조체로 빼는 것이 Factory 패턴입니다.
정말 간단하죠? 괜히 팩토리.. 이래서 지레 겁먹지 말자구요!!

</br>

## IRL (In Real Life)

유용하게 사용할 수 있는 예시로 UICollectionView의 cell을 생성하는 부분을 얘기해볼 수 있을것 같습니다.
UIcollectionView에서 다양한 종류의 셀을 사용하는 경우는 흔하게 접하는 경우이죠.

먼저 Factory 패턴을 사용하지 않은 상태로 Cell을 dequeue할 때의 예시를 보겠습니다.

**셀 클래스 정의**

```Swift
class ToggleCell: UICollectionViewCell {
    // 토글 셀 구성 로직
}

class NavigataionCell: UIColectionViewCell {
    // 내비게이션 셀 구성 로직
}

```

**UICollectionViewDataSource 구현**

```Swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = settingItems[indexPath.row]
    if type(of: item) == ToggleItem.self {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.id, for: indexPath) as! ToggleCell
      cell.configure(title: item.title)
      return cell
      
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCell.id, for: indexPath) as! NavigationCell
      cell.configure(title: item.title)
      return cell
    }
}
```

만약 이런 상황에서 새로운 셀을 추가한다고 해봅시다. 그렇게 되면 collectionView delegate에서 분기를 하나 더 따는 식의 변경에 닫혀있지 않은 코드가 되어버립니다.
즉 기존 코드를 변경 해야만 새로운 기능을 추가할 수 있다는 의미입니다.

바로 이런 경우에 팩토리 패턴을 적용할 수 있겠습니다.
바로 팩토리 패턴을 적용해 보면서 얘기 나눠보죠!

**셀 팩토리 클래스**

```Swift
final class CellFactory {
  func createCell(for item: SettingItem, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
    if type(of: item) == ToggleItem.self {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.id, for: indexPath) as! ToggleCell
      cell.configure(title: item.title)
      return cell
      
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCell.id, for: indexPath) as! NavigationCell
      cell.configure(title: item.title)
      return cell
    }
  }
}
```

</br>

**UICollectionView에서 팩토리 사용**

```Swift
extension ViewController: UIViewController, UICollectionViewDataSource {
  ...

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = settingItems[indexPath.row]
    return cellFactory.createCell(for: item, collectionView: collectionView, indexPath: indexPath)
  }

  ...
}
```

</br>

자 보면 그냥 CellFactory에서 CellType에 따라서 다른 cell을 dequeue 해주는게 전부 입니다!
진짜 별거 없죠? 진짜 이게 끝이에요..
그리고 createCell 같은 경우에 static 함수로 사용해도 전혀 무방하고 그렇게 사용하는 경우도 종종 있답니다.

그냥 다른 클래스로 로직을 빼준건데 뭔 이점이 있냐?
약간 정석적으로 얘기 해보자면

객체 생성을 중앙화 시켜 하나의 팩토리 클래스에서 집중적으로 관리할 수 있다는 이점이 있겠습니다.
또 비슷한 말이지만 객체 생성에 필요한 로직과 정보를 팩토리 클래스 내부에 숨겨 클라이언트 코드는 팩토리 클래스의 메서드를 호출해서 객체를 요청하기만 하면 됩니다.
가장 중요한 것으로는 새로운 타입의 객체를 추가하거나 생성 방식을 변경하고자 할 때 픽토리 클래스만 수정하면 되기 때문에 유지보수 측면에서 이점을 얻게되겠죠.

</br>

## 마치며

이와 비슷한 사례로 CompositionalLayout을 생성할 때에도 유용하게 사용할 수 있습니다.
여러분의 코드에서도 이런 로직이 있다면 팩토리로 캡슐화 시켜보세요~~!
