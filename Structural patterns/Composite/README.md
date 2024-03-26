# Composite

Composite 패턴은 구조적 디자인 패턴의 일종으로, 객체들을 트리 구조로 구성하여 개별 객체와 복합 객체를 클라이언트가 동일하게 다룰 수 있도록 해줍니다.
이 패턴의 핵심은 "개체(Leaf)"와 "복합체(Composite)"가 같은 인터페이스를 공유한다는 것입니다.

개체와 복합체? 뭔가 와닿지 않죠?
하지만 이런 구조는 이미 우리가 모르는 사이에 수많이 접했을 겁니다.

예를들어 아이폰의 설정을 생각해 볼게요.
설정에는 여러 설정 아이템들이 있고 그 아이템 자체로 어떤 설정 페이지로 넘어갈 수도 있고 해당 아이템을 클릭했을때 다시 다른 설정 아이템들의 묶음으로 넘어갈 수도 있죠? 마치 파일과 디렉토리로 구성 되어있는 폴더 구조처럼요!

<img src="Resources/composite pattern structure.png">

이렇게 하위의 하위의 하위의.. 객체. 이렇게 트리 형태로 구조화할 수 있는 것을 composite 패턴을 이용하면 쉽게 관리할 수 있게 됩니다!

### 구성 요소

Composite 패턴은 다음과 같은 구성요소를 가집니다.

- **컴포넌트**: 개체와 복합체가 공통으로 구현하는 인터페이스입니다. 이 인터페이스는 개체와 복합체가 수행해야 하는 작업을 정의합니다.
- **리프**(Leaf): 컴포지트 구조의 기본 요소로, 컴포넌트 인터페이스를 구현합니다. 리프는 다른 객체를 포함할 수 없는 단순 객체입니다.
- **컴포지트**(Composite): 여러 개의 컴포넌트(리프 또는 다른 컴포지트)를 포함할 수 있는 복합 객체입니다. 컴포지트는 컴포넌트 인터페이스를 구현하며, 내부적으로 자식 컴포넌트 목록을 관리합니다.

</br>

## IRL (In Real Life)

자 그럼 위에서 예시로 들었던 설정 구조를 Composite 패턴을 이용해서 가볍게 구현해보면서 좀 더 명확히 이해해보자구요!

일단 구성요소를 하나하나 구현해 나가볼게요.

### Component 구현

Component는 개체와 복합체가 각각 수행해야하는 작업을 의미하는데요.
다음과 같이 구현해볼 수 있겠네요.

```Swift
protocol SettingComponent {
  var title: String { get }
  func render() -> AnyView
}

```

이것만으로는 Component가 뭐하는 녀석인지는 아직 감이 안 옵니다..

### Leaf 구현

이어서 Leaf를 구현해 볼게요!

```Swift
struct AskToJoinNetworks: SettingComponent {
  var title: String
  
  func render() -> AnyView {
    AnyView(
      NavigationLink(destination: {
        Text("\(title) 설정 화면")
      }, label: {
        Text(title)
      })
    )
  }
}

```

이렇게 SettingComponent(공통) 프로토콜을 채택한 메뉴 아이템을 만들었습니다.
얘는 이제 Leaf이기 때문에 뭐 하위 메뉴를 또 만든다거나 할 수 없이 얘 자체로 끝 입니다.

예를들면 소프트웨어 업데이트 페이지에서 더이상 네비게이션 되는 메뉴아이템이 없는것 처럼요! (실제로 있긴한데 일단 이해를 돕기 위해서 그렇다고 합시다.)

**Composite 구현**
만약 Leaf의 하위 Leaf들을 구성(예를들면 설정 -> 일반 으로 들어가면 또 하위 아이템들이 있는것 처럼)하고 싶다면 해당 Leaf는 Composite으로 승격시켜서 사용하면 됩니다.
여기서 승격 시킨다는 것을 별 대단한 건 아니구요 그냥 하위 leaf들을 가지고 있을 수 있는 array 그리고 추가할 수 있는 함수를 가지고 있음을 의미합니다.

하지만 본질적으로 얘도 결국 SettingComponent를 채택하고 있기 때문에 또 다른 Compite의 array에 포함되거나 할 수 있습니다.
이게 Composite이 복잡한 구조를 단순하게 관리할 수  있는 핵심이죠!

자 그럼 아까 위에서 만든 AskToJoinNetwork는 실제로 Wifi 설정 하위에 있기 때문에 우리도 Wifi 라는 상위 Composite을 만들어보면 되겠죠?

```Swift
protocol Compositable {
  var leaves: [SettingComponent] { get set }
  mutating func addComponent(_ component: SettingComponent)
}

extension Compositable {
  mutating func addComponent(_ component: SettingComponent) {
    self.leaves.append(component)
  }
}

struct WifiSetting: SettingComponent, Compositable {
  var title: String
  var leaves = [SettingComponent]()
  
  func render() -> AnyView {
    AnyView(
      NavigationLink {
        List {
          ForEach(leaves.indices, id: \.self) { index in
            self.leaves[index].render()
          }
        }
      } label: {
        Text(title)
      }
    )
  }
}
```

위처럼 처럼 WifiSetting(Composite)객체가 하위 SettingComponent들을 가지고 있을 수 있게 된걸 볼 수 있습니다.
이렇게 하위 leaf들을 포함할 수 있으면서 동시에 leaf와 같은 SettingComponent를 채택하고 있는 녀석이 Composite 입니다.

(저는 반복해서 작성하는게 귀찮아서 Composite이 되는 SettingCompoent는 공통 로직을 따로 구현된 프로토콜로 빼서 사용하겠습니다.)

아무튼 이렇게 구현했으니 사용해 봐야겠죠?

```Swift
// 얘가 Composite
var wifiSetting = WifiSetting(title: "Wi-Fi")

// 그리고 Leaf가 Composite 하위로 들어가는 모습
wifiSetting.addComponent(AskToJoinNetworks(title: "Ask to Join Networks")) 
```

자! 어떤가요? 상당히 직관적이죠??

여기에 또 하위 Leaf들을 추가한다면 아래와같이 표현할 수 있겠네요.
그리고 Composite은 또 다른 Composite의 leaf로도 들어갈 수 있으니 아래와 같이 작성하면 network setting 이라는 더 큰 카테고리 안에 담길 수 있겠네요!

```Swift
    ...
    
    // 🗼. 네트워크 설정 그룹
    var networkSetting = NetworkSetting(title: "Network Setting")
    
    // 🗼 > 🛜. Wifi 설정
    var wifiSetting = WifiSetting(title: "Wi-Fi")
    // 🗼 > 🛜 > 💭. 네트워크 접속시 물어보기
    wifiSetting.addComponent(AskToJoinNetworks(title: "Ask to Join Networks"))
    // 🗼 > 🛜 > 🔥. 핫스팟
    wifiSetting.addComponent(Hotspot(title: "Hotspot"))
    
    ...
```

이런식의 복잡한 트리 구조를 관리할때 Composite 패턴이 상당히 유용히 사용될 수 있습니다.

예시 프로젝트에는 이보다 조금 더 복잡하게 구성해놨으니 예시도 보면서 이해를 도와보세요!

(실제로 사용할 때에는 최적화 같은것도 같이 고려해 보세요 🙂)

</br>

## 실행 화면

![preview](./Resources/preview.gif)
