# Builder

빌더 패턴은 객체를 생성하는 단계를 여러개로 나누어서 관리할때 도움이 되는 디자인 패턴 입니다.

역시 정의 자체로는 이게 뭐하는 녀석인지 이해하기란 쉽지 않습니다.
Before, After 예시로 이해를 도와보죠.

예를 들어 다음과 같이 Document 객체가 있다고 해볼게요.
이 객체에는 뭘 넣느냐에 따라서 다양한 결과가 나오겠죠?

```SWift
// 생성 시 모든 매개변수를 명시해야 하며, 매개변수의 순서와 의미를 정확히 알아야 함
let document = Document(title: "Swift Design Patterns", 
                        author: "John Doe", 
                        text: "Full text of the document", 
                        pageCount: 120, 
                        summary: "A brief summary of design patterns in Swift", 
                        keywords: ["design", "patterns", "swift"])

```

이렇게 유연성은 생기지만 객체 구조에 대해서 클라이언트가 모두 알아야하고 특히 optional 로 받아야하는 요소들에 대해서도 처리를 해줘야겠죠.

그럼 이거를 Builder 패턴을 적용해서 만들어 사용하는 모습을 봐볼까요?

```Swift
let builder = DocumentBuilder()
builder.setTitle("Swift Design Patterns")
builder.setAuthor("John Doe")
builder.setText("Full text of the document")
builder.setPageCount(120)
builder.setSummary("A brief summary of design patterns in Swift")
builder.setKeywords(["design", "patterns", "swift"])

let document = builder.build()
```

어떤가요? 훨씬 체계적이고 유연해 보이죠?
그리고 저 setSummary, setKeywords 같이 optional 한 요소들에 대해서는 생성자 처럼 기본값을 넣어준다거나 할 필요없이 애초에 호출하지 않으면 되는 것이죠.

게다가 setTitle, setAuthor 등 함수들을 protocol로 담아서 관리하면 클라이언트 입장에서는 추상 인터페이스만 보고있기 때문에 구현 코드는 어떻게 바뀌던 상관 없겠죠.

### Method Chaining

그리고 제가 생각하기에 builder의 꽃은 method chaining에 있다고 생각하는데 이를 구현하는 건 뒤에서 보고 일단 적용한 모습부터 보면 아래와 같습니다.

```Swift
let builder = DocumentBuilder()
let document = builder.setTitle("Swift Design Patterns")
                        .setAuthor("John Doe")
                        .setText("Full text of the document")
                        .setPageCount(120)
                        .setSummary("A brief summary of design patterns in Swift")
                        .setKeywords(["design", "patterns", "swift"])
                        .build()
```

주먹구구식으로 생성자에 다 때려박는거 보다 훨 섹시하지 않나요?

이렇게 생성하려는 객체가 매우 복잡할 경우 (특히 많은 매개변수를 필요로 하거나, 객체 생성 과정이 여러 단계를 포함하는 경우)에 유용하게 사용됩니다.

</br>

## IRL (In Real Life)

자 그럼 써먹어봐야겠죠?

빌더 패턴을 이용해서 기존 Aelrt보다 훨 사용하기 쉽고 가독성 좋은 Alert를 만들어보겠습니다.

일단 빌더 프로토콜을 하나 만들어 주겠습니다.

```Swift
protocol AlertBuilder {
  func setTitle(_ title: String) -> AlertBuilder
  func setMessage(_ message: String) -> AlertBuilder
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> AlertBuilder
  func build() -> UIAlertController
}

```

프로토콜을 보면 각 함수들이 빌더 자기자신을 리턴하는 것을 볼 수 있습니다.

**바로 이게 연쇄적으로 다른 빌더의 함수를 호출할 수 있게 도와주는 메소드 체이닝의 핵심이 되겠습니다.**

아마 사용하는 모습까지 보시면 왜 자기자신을 리턴하는 이유에 대해서 더 이해하기 쉬우실 겁니다.

그럼 이어서 이 프로토콜을 구현해줘보죠.

```Swift
class CustomAlertBuilder: AlertBuilder {
  private var title: String?
  private var message: String?
  private var actions: [UIAlertAction] = []
  
  @discardableResult
  func setTitle(_ title: String) -> AlertBuilder {
    self.title = title
    return self
  }
  
  @discardableResult
  func setMessage(_ message: String) -> AlertBuilder {
    self.message = message
    return self
  }
  
  @discardableResult
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> AlertBuilder {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    actions.append(action)
    return self
  }
  
  func build() -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach { alert.addAction($0) }
    return alert
  }
}


```

이렇게 빌더의 각 함수는 우리가 필요한 객체의 수정을 도와줍니다.

최종적으로 이렇게 만든 빌더를 사용하는 모습을 보겠습니다.

```Swift
let builder = CustomAlertBuilder()
let alert = builder
  .setTitle("스위프트 디자인 패턴")
  .setMessage("스위프트 디자인패턴을 배워봅시다")
  .addAction(title: "취소", style: .cancel, handler: nil)
  .addAction(title: "설정으로 이동", style: .default) { _ in
 UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }
  .build()

present(alert, animated: true)
```

자 어떤가요? 깔끔하죠?

사실 아래처럼 전통적으로 UIAlertController 생성해주는 거랑 별 안 다르지 않음? 이라고 생각하실 수 있습니다.

```Swift
let alert = UIAlertController(title: "스위프트 디자인 패턴", message: "스위프트 디자인패턴을 배워봅시다", preferredStyle: .alert)
alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}))
```

네, 예시가 UIAlertController라 그렇지 만약에 생성자에 10개 이상의 값을 넘겨줘야한다면요?
사용하지 않는 객체에 옵셔널 처리 또는 여러개의 생성자를 만드는 데 하루를 꼬박 보낼지도 모릅니다

이처럼 생성자를 이용해서 클라이언트로부터 다양한 객체를 생성하게 하는데 생성자가 좀 비대하다? 그럼 Builder 패턴의 도입을 적극 고려해보세요!

그리고 빌더패턴은 기존에 객체를 생성하는 방식보다 훨씬 가독성이 좋아진다는 이점도 있습니다.
특히 클로져를 가진 생성자 프로퍼티가 많다면요!
