# Abstract Factory

추상 팩토리는 서로 관련 있거나 의존성이 있는 객체들의 그룹을을 생성하는 인터페이스를 말합니다.

역시 뭔소린지 모르겠죠?

그냥 객체를 생성하는 함수들을 여러개 모아둔 프로토콜을 얘기하는 겁니다.
하여간 이 디자인 패턴들은 이름이 거창해서 문제인 듯 합니다.
이름만 더 직관적이었어도 이해하기 훨씬 쉬웠을텐데 말이죠..

</br>
근데 이러면 "야 그럼 그냥 프로토콜 만들고 그거 구현하면 그거 추상 팩토리 사용했다고 할 수 있는거 아님?"
이라고 할 수 있는데요. 네 제가 그랬습니다.

</br>
일단 아닙니다. POP는 맞는데.. 이거 패턴 이름이 뭔가요?
추상 팩토리 입니다.
팩토리는 뭔가요? 공장이죠?
뭘 만들어줘야한다는 뜻 입니다.
그러니까 아래와 같은 추상 함수들로만 구상 되어있어야 하는거죠.

```Swift
func createObject() -> Object
```

</br>
그럼 여기서 또 의문이 들겁니다.
이거.. 팩토리 메서드 아님?!

틀린말은 아닙니다.
다만 가장 중요한 차이점으로는 추상 팩토리의 경우 **서로 연관되거나 의존적인** 그러니까 일련된 객체들을 생성해주는 추상 함수들을 모아준 것을 의미합니다.
</br>
</br>
즉
</br>
**팩토리 메서드**

- 객체를 생성하는 구현을 서브 클래스에게 넘김
- 여러개여도 상관 X
- 일관되지 않아도 상관 X

</br>

**추상 팩토리**

- 객체를 생성하는 구현을 서브 클래스에게 넘김
- 여러개이어야 함.
- 왜냐하면 일관되어야 하니까 (일관이라는 단어는 하나의 것을 얘기할 때에는 적합하지 않음, 적어도 두 개 이상이 되어야 일관된다고 얘기할 수 있음.)

뭐 이런 차이가 있는 것이죠.
간혹 어떤 글에서는 팩토리 메서드가 하나의 객체 생성 함수만 있는거고 추상 팩토리가 여러개의 객체 생성 함수가 있는거다 이러는데 위 개념에 포함된 말은 맞는데 맞는 말은 아닙니다.

</br>

## IRL (In Real Life)

자 그럼 사용해 보아야겠죠?
예를 들어서 내 앱에 카카오톡 처럼 다양한 테마를 지원한다고 가정해볼게요.

그러면 다양한 테마에 따라서 챗 버블이나 다양한 UI 요소들을 달리 생성하는 팩토리를 만들어 본다고 할 때 아래와같이 프로토콜을 정의할 수 있겠죠?

```Swift
protocol ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView
  func createMyChatBubble(text: String) -> AnyView
  func createBackground() -> AnyView
}
```

자 넘어가기전에 이게 추상 팩토리 패턴이라고 불릴 수 있는 이유를 봅시다.
createOpponentChatBubble, createMyChatBubble, createBackground 모두 protocol을 통해서 구현을 서브클래스(또는 구조체)에게 넘기고있죠?

그리고 또 일련 된 AnyView 객체들을 생성해주고있죠? (만약 UIKit 이라면 UISwitch, UIView, UIButton 등 다양하게 있어도 일련 되었다고 말할 수 있음)
만약 쌩뚱맞게 createPizza 이런거 포함되어있으면 그 순간 추상 팩토리가 아니라 팩토리 메서드가 되겠죠?

그럼 이어서 구현을 해보겠습니다.

```Swift
struct MuziThemeFactory: ThemeFactory {
  func createOpponentChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color.white)
        .foregroundStyle(Color.black)
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.black, lineWidth: 1.0)
        )
    )
  }
  
  func createMyChatBubble(text: String) -> AnyView {
    AnyView(
      Text(text)
        .padding(8)
        .background(Color(hex: "#FEF2B5"))
        .foregroundStyle(Color.black)
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.black, lineWidth: 1.0)
        )
    )
  }
  
  func createBackground() -> AnyView {
    AnyView(
      Color(hex: "#FFED71")
    )
  }
}


// 위와 비슷한 방식으로 구현
struct MuziThemeFactory: ThemeFactory { ... }
struct ConThemeFactory: ThemeFactory { ... }
```

자 이렇게 만들면 사용자 입장에서는 아래와같이 사용할 수 있겠죠

```Swift
struct ContentView: View {
  
  // MARK: - Properties
  
  enum Theme: String, CaseIterable {
    case muji
    case apeach
    case con
    
    var factory: ThemeFactory {
      switch self {
      case .muji:
        return MuziThemeFactory()
      case .apeach:
        return AppeachThemeFactory()
      case .con:
        return ConThemeFactory()
      }
    }
  }
  
  @State private var currentTheme: Theme = .muji
  
  
  // MARK: - Views
  
  var body: some View {
    VStack {
      HStack {
        currentTheme.factory.createOpponentChatBubble(text: "안녕하세요")
        Spacer()
      }
      
      HStack {
        Spacer()
        currentTheme.factory.createMyChatBubble(text: "안녕하세요☺️")
      }
      
      HStack {
        Spacer()
        currentTheme.factory.createMyChatBubble(text: "아래에서 segment에서 테마를 선택할 수 있어요")
      }
      
      Spacer()
      
      Picker("테마를 선택해 주세요", selection: $currentTheme) {
        ForEach(Theme.allCases, id: \.self) { theme in
          Text(theme.rawValue)
        }
      }
      .pickerStyle(.segmented)
    }
    .padding(12)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      currentTheme.factory.createBackground()
        .ignoresSafeArea()
    )
  }
}
```

</br>
</br>

어떤가요? 이렇게 그룹화 된 추상화를 사용하게 되면 클라이언트 코드 간의 단단한 결합도 느슨하게 해주고 만약 새로운 테마를 추가한다고 하면 단순히 ThemeFactory 를 채택한 구현체를 만들어서 사용하면 되겠죠? 그러면서 자연스럽게 SRP, OCP도 챙길 수 있겠죠.

이처럼 어떤 제품군을 만들때 특히 추상 팩토리가 유용하게 사용됩니다.
