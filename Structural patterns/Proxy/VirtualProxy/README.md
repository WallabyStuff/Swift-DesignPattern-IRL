# 가상 프록시 (지연 초기화)

지연 초기화 프록시 라고 이름 지어도 괜찮을 것 같은데 가상 프록시라고 해서 상당히 있어보이는 가상 프록시에 대해서도 알아보겠습니다.

가상 프록시는 객체를 초기화하는 작업 자체가 많이 무거울 때 유용하게 사용될 수 있습니다.

예를들어서 다음과 같은 프로토콜이 있고 이를 채택하는 객체가 있다고 해볼게요.

```Swift
protocol ExpensiveObject {
    func performAction()
}

class RealExpensiveObject: ExpensiveObject {
    init() {
        print("와.. 초기화만 하는데도 빡세!!!")
        // 비용이 많이 드는 초기화 작업
    }

    func performAction() {
        print("작업을 수행하겠습니다.")
    }
}

```

자 그럼 초기화에서 힘든 작업을 한다고 하면 그냥 객체를 초기화해서 가지고 있는 것 만으로도 상당한 손해가 일어나겠죠?
더군다다 performAction()을 사용하지도 않을 것 이라면요!?

굉장한 손해가 아닐 수 없습니다...

여기에서 가상 프록시라는 녀석이 객체 자체를 지연 초기화 시켜주도록 해줍니다.
이게 가능한것은 구조적으로 프록시라는 녀석이 실제 객체를 인스턴스로 가지고있기 때문에 가능한 것이죠.

코드로 보면 좀 더 이해가 쉬울 겁니다.

```Swift
class LazyExpensiveObjectProxy: ExpensiveObject {    // 👈 이거 프록시 종특
    private lazy var realObject: RealExpensiveObject = RealExpensiveObject()   // 👈 이거 프록시 종특 다만 가상 프록시는 실제 객체를 lazy 하게 가지고 있음

    func performAction() {                           // 👈 프록시가 대리 호출해주는 거임.
        realObject.performAction()
    }
}
```

일케 해주고 아래처럼 사용한다고 하면 performAction이 호출될 때까지는 초기화가 안 되겠죠?

```Swift
let proxyObject = LazyExpensiveObjectProxy()
print("프록시 객체 만들어짐")

// 실제 객체는 아래 줄이 실행될 때 초기화됩니다.
proxyObject.performAction()

```

이런 느낌으로 최적화를 해줄 수 있겠습니다.

근데 이거 그냥 첨부터 RealExpensiveObject 객체를 lazy 하게 전역 변수로 갖고있다가 사용하면 되는거 아님!?!?!?
예 맞습니다, 그래서 만약 로컬변수로 밖에 사용할 수 없을때 사용하면 되겠죠? 또는 다양한 프록시를 짬뽕 시킬 수도 있고 실제 객체의 생성 로직을 캡슐화하고, 클라이언트로부터 숨긴다는 점에서도 이점이 있을 수 있겠습니다.

암튼 이런 식으로도 사용된다~ 라고 알아주시면 될 것 같습니다.
