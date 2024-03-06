# 보호 프록시 (접근 제어)

보호 프록시는 기존 객체의 엑세스를 제한적으로 사용하도록 만들어주는 프록시 입니다.
그러니까 직접 객체의 함수들을 불러와서 이상한 분기까지 말고 보호 프록시 통해서 함수 호출하고 엑세스 수준에 맞는 적절한 결과 받아서 써라~ 이런거죠.

코드로 보면 이해가 더 잘 되실겁니다.

예를들어서 도큐멘트가 있다고 해보겠습니다.
이때 접근 권한은 어드민, 게스트 이렇게 두 가지로 나뉜다고 해볼게요.

```Swift
enum UserRole { 
   case admin 
   case guest 
}
```

document에는 아래와같이 display() 즉 도큐멘트를 열어서 볼 수 있는 기능이 있습니다.

```Swift
protocol Document {
  func display() -> AnyView
}
```

그리고 아래코드와 같이 Document를 채택하는 나만의 document 구조체를 만들어주었습니다.

```Swift
struct MyDocument: Document {
  func display() -> AnyView {
    let url = Bundle.main.url(forResource: "sample", withExtension: "pdf")!
    return AnyView(PDFKitView(url: url))
  }
}
```

자 여기에서 만약 UserRole이 게스트인 경우에 도큐멘트를 못 보게 막고싶다고 해볼게요.

```Swift
...

let documnet = MyDocument()

if userRole == .admin {
    documnet.display()
} else {
    print("너 권한 없음;")
}

...
```

뭐 이런식으로 할 수 있겠죠?
별 문제 없어보입니다.

하지만 개발자라면 최악의 상황들도 생각해볼 줄 알아야합니다!
자... 최악의 상황을 생각해 볼게요.

만약에 저 document.display() 를 호출하는 곳이 저쪽 뿐만이 아니라 다른 곳에도 있다고 해봅시다.
그것도 한... 100 곳에서요.

그럼 거기서 UserRole에 따라서 하나하나 다 분기 까줘야겠죠?

거기에서 또 만약 UserRole이 추가가 되었어요. 그럼 100군데 하나하나 돌아다니면서 분기 다시 수정해 줘야겠죠?

끔찍하네요🫠

이때 저 접근제어만 따로 관리해주는 녀석을 만들어보면 좋을것 같은데... 관리해주는.. 대리자..... 아!!! 프록시!!!!(ㅋㅋ;;;)
이렇게 프록시가 떠올랐다니 바로 만들어볼게요.

프록시의 종특으로는 기존 객체의 동작들을 정의하고있는 protocol 을 프록시에서도 동일하게 채택하고 원본 객체는 프록시 내부 인스턴스로 가지고있다고 하였습니다.

아래처럼요!

```Swift
struct DocumentProxy: Document { // 👈 이거 프록시 종특
  
  private let userRole: UserRole
  private let document: any Document
  
  init(userRole: UserRole, document: any Document) {
    self.userRole = userRole
    self.document = document
  }
  
  func display() -> AnyView {
    switch userRole {
    case .guest:
      return AnyView(
        VStack {
          Text("🤚")
            .font(.system(size: 60))
          
          Text("접근 권한이 없습니다")
            .foregroundStyle(Color.black)
            .opacity(0.5)
        }
      )
      
    case .admin:
      return document.display() // 👈 이거 프록시 종특 DocumentProxy가 document와 같은 protocol을 채택함으로 display를 대리해서 호출해주는 모습
    }
  }
}


```

예 이렇게 구현하면 이제 클라이언트는 아래처럼 프록시를 통해서만 함수를 호출해주면 되겠습니다.

```Swift
let myDocument = MyDocument()
let documentProxy = DocumentProxy(userRole: userRole, document: myDocument)
documentProxy.display()
```

자 이러면 아까 생각해본 최악의 상황들,, 100군데 분기 깐 곳 찾아서 일일이 유지보수 해주지 않고 그냥 프록시의 display 함수에서만 유지보수해주면 되겠죠? 고오급 용어로는 OCP 를 잘 준수했다~ 라고 할 수 있습니다.

이렇게 보호프록시를 이해하셨다면 실제 Swift로 앱을 제작하면서 어디에 사용하면 적절할지 막 아이디어가 솟구칠 것이라 생각이 듭니다. (절대 실사례 작성하기 귀찮아서 그런거 아님)

예를들면 UserRole이 아닌 위도 경도 값에 따라서 일부 지역에서 컨텐츠 접근을 Proxy에서 제한 한다던지..?  암튼 저보단 여러분들의 상상력이 더 좋을것이라 믿습니다!!
