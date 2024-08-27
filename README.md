# ReactnativeProgramming

- Import PackageManager

```php
https://github.com/ReactiveX/RxSwift.git
```


Giới thiệu: `RxSwift` sẽ gồm 2 phần chính
- `RxSwift`: dành cho ngôn ngữ Swift
- `RxCocoa`: dành cho nền tảng IOS


# I. Hello World

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear(perform: {
            let helloRx = Observable.just("Hello RxSwift")

            helloRx.subscribe { (value) in
                    print(value)
            }
        })
        .padding()
    }
}
```


Output:

```php
next(Hello RxSwift)
completed
```


Giải thích:
- Ta có `helloRx` là một biến kiểu `Observable`.
- Trong đó `Observable` là nguồn phát dữ liệu. Trong ví dụ trên, kiểu dữ liệu phát ra là `String` và dữ liệu phát đi là chữ `Hello RxSwift`.
- `just` là ám chỉ việc `Observable` này được tạo và phát đi 1 lần duy nhất, sau đó kết thúc.
- Để lắng nghe những gì mà `helloRx` phát ra thì ta cần `subscribe` tới nó. Chúng ta cần cung cấp 1 `closure` để xử lý các giá trị được nhận từ nguồn phát.
- Về giá trị nhận được: Sau khi nguồn phát ra `Hello RxSwift`, nguồn phát tiếp tục phát ra tín hiệu kết thúc `completed`.


```swift
.onAppear(perform: {
    let helloRx = Observable.just("Hello RxSwift")
    print("DEBUG: siuuuuu")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        helloRx.subscribe { (value) in
            print(value)
        }
    }
})
```

Output:

```php
DEBUG: siuuuuu
next(Hello RxSwift)
completed
```


Ta thấy cứ thằng nào subscribe đều sẽ nhận được bản tin.
- `Một đối tượng Observable sẽ phát đi dữ liệu khi nó được một đối tượng khác (hay cái gì đó) đăng ký tới.`


# II. Observables – Trái tim của RxSwift

Đây là phần trung tâm của `RxSwift`. `Observable` chính là trái tim của cả hệ thống. Là nơi mà các thành phần khác có thể quan sát, lắng nghe được. Nó tác động trực tiếp tới giao diện của ta, dựa vào những gì mà nó phát ra.

## 2.1 Khái niệm

Khi tìm hiểu về `RxSwift` hay `Rx` nói chung, bạn sẽ nghe tới các khái niệm `observable`, `observable sequence` hay đơn giản là `sequence`. Khá là mơ hồ nhưng tất cả chúng đều là một và ám chỉ tới `nguồn phát`. Khác nhau ở góc độ mà họ muốn mình hiểu.

- `Observable`:  là nguồn phát ra dữ liệu mà các đối tượng khác có thể quan sát được và đăng ký tới được.
- `Sequence`: là luồng dữ liệu được nguồn phát phát đi. Vấn đề quan trọng, ta cần `hiểu nó như 1 Array`, nhưng chúng ta không thể lấy hết 1 lúc tất cả các giá trị của nó. Và chúng ta không biết nó lúc nào kết thúc hay lúc nào lỗi...

## 2.2 Vòng đời Observables

### 2.2.1 Asynchronous data streams

Tạm dừng một chút, khi ta quay lại một trong những định nghĩa lớn cho `RxSwift` hay cho toàn bộ `Reactive Programming` như sau: **Reactive programming is programming with asynchronous data streams.**

 - Và ta nên tập trung vào luồng dữ liệu bất đồng bộ. Nó không phải là kiểu lập trình hay xử lý đa luồng. `Chính xác đây được hiểu là thời điểm mà dữ liệu trong luồng được phát đi`. `Nó không đồng bộ với nhau và cũng không xác định theo một thời gian cụ thể nào đó`.
- Cuối cùng, nó không chỉ là dữ liệu. Ta nên hiểu nó ở mức độ tương đối. Vì đôi khi, kiểu dữ liệu của ta sẽ là các sự kiện hoặc là một nguồn phát.


### 2.2.2 Observables life cycle

Cuộc đời của một `Observable` rất chi là đơn giản. `Nó chỉ có một nhiệm vụ là bắn những gì mà nó có đi thôi`. Nên cuộc đời nó sẽ xoay quanh giá trị và nó bắn đi. Với 3 kiểu giá trị mà 1 `Observable` được phép bắn đi như sau:

- `value`: chính là giá trị dữ liệu nguồn phát phát đi (hay còn gọi là `emit`).
- `Error`: là lỗi khi có gì đó sai sai trong quá trình hoạt động. Sau đó nó cũng tự kết thúc
- `Completed`: kết thúc cuộc đời.  //Hmm hơi khả nghi.


Thông qua 3 giá trị đó thì mô tả vòng đời `Observable` như sau:

- Khởi tạo `Observable`
- Cứ `onNext` là sẽ phát giá trị đi.
- Quá trình này cứ lặp đi lặp lại cho tới khi:
  - Hết thì sẽ là `completed`
  - Lỗi thì sẽ là `error`
- Khi khi đã `completed` hoặc `error` thì `Observable` không thể phát ra được gì nữa –> kết thúc.


### 2.2.3 Cách tạo Observables

Tạo các `Observables` thông qua việc thực thi các toán tử sau `just`, `of` và `from`. 

- `just`:

```swift
let iOS = 1
let observable1 = Observable<Int>.just(iOS)
```

Tại sao là `just`? Thì cái tên này cũng nói lên tất cả rồi. `Nó sẽ tạo ra 1 Observable và phát đi 1 giá trị duy nhất. Sau đó, nó sẽ kết thúc.`


- `of`:


```swift
let iOS = 1
let android = 2
let flutter = 3

let observable2 = Observable.of(iOS, android, flutter)
```

Theo ví dụ trên, kiểu dữ liệu của `observable2` là `Observable<Int>`. Để hiểu kĩ hơn, ta biến tấu nó thêm một chút nữa. Ta xem đoạn code sau:

```swift
let observable3 = Observable.of([iOS, android, flutter])
```

Cũng vẫn là `of`, nhưng kiểu dữ liệu cho `observable3` lúc này là `Observable<[Int]>`. Nó khác cái trên ở chỗ kiểu cho mỗi giá trị phát ra là 1 Array Int, chứ không phải Int riêng lẻ. 


- `from`:

```swift
let observable4 = Observable.from([iOS, android, flutter])
```

Lần này, sử dụng toán tử from, tham số cần truyền vào là 1 array. Và kiểu dữ liệu cho biến `observalbe4` là `Observable<Int>`. Cách này giúp ta đỡ phải `of` nhiều phần tử. 


### 2.2.4 Subscribing to Observables

- `addObserver`:
Có được nguồn phát rồi, công việc hiện tại là lắng nghe nó thôi. Mình chắc là bạn cũng đã ít nhiều lần code với `KVO` trong iOS rồi. Đó là hình thức sơ khai cho mô hình (Reactive Programming) này. Đây là ví dụ cho việc lắng nghe từ sự kiện của bàn phím.

```swift
let observer = NotificationCenter.default.addObserver( forName: UIResponder.keyboardDidChangeFrameNotification, object: nil,
queue: nil) { notification in
  // Handle receiving notification
}
```

`RxSwift` cũng tương tự vậy thôi. Trong `UIKit` hay các thư viện được build sẵn trong OS của Apple, `các singleton cũng có khả năng phát đi được dữ liệu. Đó chính là thuyết âm mưu mà Apple đã âm thầm cài đặt lâu nay.`


- `Subscribe`

```swift
.onAppear(perform: {
    let iOS = 1
    let android = 2
    let flutter = 3
    
    let observable1 = Observable<Int>.just(iOS)
    
    observable1.subscribe { event in
        print(event.element)
    }
})
```


Output:

```php
next(1)
completed
```

Tuy nhiên, có cái chữ `next` & `completed` cũng khó chịu. Muốn lấy được giá trị trong chữ đó, ta phải biến tấu thêm 1 xí nữa.

```swift
observable2.subscribe { event in
    if let element = event.element {
        print(element)
      }
}
```

oputput:

```php
1
2
3
```


### 2.2.5 Handle events

Tiếp theo, nếu bạn cần lấy thêm các sự kiện error hay completed thì lại biến tấu tiếp.


- Dành cho `onNext`:

```swift
observable3.subscribe(onNext: { element in
      print(element)
})
```


- Full options:

```swift
observable4.subscribe(onNext: { (value) in
        print(value)
    }, onError: { (error) in
        print(error.localizedDescription)
    }, onCompleted: {
        print("Completed")
    }) {
        print("Disposed")
    }
```


### 2.2.5 Các dạng đặc biệt của Observables

- `Empty`: Đây là toán tử mà nó tạo ra 1 `Observable`. `Observable` này đặc biệt là không phát ra phần tử nào hết và nó sẽ kết thúc ngay.

```swift
let observable = Observable<Void>.empty()

observable.subscribe(
    onNext: { element in
    print(element)
},
    onCompleted: {
    print("Completed")
    }
)

//Ouput: Completed
```

- `Never`: 

```swift
let observable = Observable<Any>.never()
    
observable.subscribe(
    onNext: { element in
        print(element)
    },
    onCompleted: {
        print("Completed")
    }
)
```

- Bạn cũng thực thi đoạn code trên, bạn sẽ thấy hoàn toàn im lìm. Không có gì ở đây được phát và được nhận hết. `Toán tử .empty nó khác với .never nha. Never thì sẽ không phát ra gì cả và cũng không kết thúc luôn.`


- `Range`:

```swift
let observable = Observable<Int>.range(start: 1, count: 10)
    var sum = 0
    observable
        .subscribe(
            onNext: { i in
                sum += i
        } , onCompleted: {
            print("Sum = \(sum)")
        }
    )
```


Nó giống như một vòng for đơn giản. Observable với kiểu phần tử được phát đi là Int. Chúng sẽ phát ra lần lượt, số lần phát chính là count và giá trị bắt đầu phát ra là start. Sau mỗi lần phát thì start sẽ được tăng lên 1 đơn vị.

### 2.2.5 Tổng kết


- `Observables` là nguồn phát dữ liệu.
- `Sequence`, `Observable` `Sequence` hay `Stream` đều mang ý nghĩa giống nhau.
- Có 3 cách tạo 1 `Observables` đơn giản:
  - `just` phát ra phần tử duy nhất và kết thúc
  - `of` phát ra lần lượt các phần tử cung cấp và kết thúc
  - `from` tương tự như `of` mà tham số truyền vào là 1 array, tiết kiệm thời gian ngồi gõ code
- Các observable đặc biệt:
  - `empty` không có gì hết và kết thúc.
  - `never` không có gì luôn và không kết thúc luôn.
  - `range` tạo ra 1 vòng for nhỏ nhỏ, dùng cho Int và mỗi lần như vậy thì sẽ tăng giá trị lên.

# III. DisposeBag

Điểm nguy hiểm nhất khi sử dụng `RxSwift` (hay Reactive Programming) là việc quản lý bộ nhớ. Nó không hoàn toàn tự động và không được tối ưu. Khi có quá nhiều nguồn phát và quá nhiều đối tượng lắng nghe tới các nguồn phát đó, thì ta có dám chắc rằng ta đã giải phóng tất cả các đối tượng hay không.

- `Một đối tượng Observable sẽ phát đi dữ liệu khi nó được một đối tượng khác (hay cái gì đó) đăng ký tới.`

## 3.1 Vấn đề

Ta chỉ cần tò mò một chút thì sẽ có nhiều vấn đề trong cơ chế hoạt động trên. Như:
- Nếu `Observable` không kết thúc thì sao nào?
- Không muốn nhận nữa mà `Observable` vẫn cứ phát dữ liệu đi?
- Chã lẻ lúc nào cũng phải mang theo 1 closure để đi `subscribe Observable`.
- Có nên huỷ nó hay không huỷ nó, khi phải làm việc với bất đồng bộ. Như đang chờ dữ liệu từ API trả về...
- Lỡ quên huỷ mất tiêu … thì có toang không ta?

Quá nhiều, chắc cũng phải tới 1001 lý do ở đây rồi. Nhưng ta chỉ cần quan tâm là mối liên kết giữa chúng không bị giải phóng. Dù ít hay nhiều thì bộ nhớ của thiết bị sẽ bị chiếm dụng. Nguy hiểm hơn là chúng ta sẽ không handle được sự thay đổi tới các thành phần khác mà cùng đăng ký tới `Observable`.


## 3.2 DisposeBag

`DisposeBag`, `Dispose` & `Disposable` thì chỉ có trong nền tảng `RxSwift` và nó không tương đồng với các nền tảng khác trong đa vũ trụ Rx. Đây là cơ chế giúp cho `RxSwift` có thể quản lý bộ nhớ của mình được tốt nhất. Đây cũng là `cách nhanh nhất đơn phương kết thúc một đăng ký (subscription) từ phía người đăng ký (subscriber). Mà không cần đợi nguồn phát phát đi error hay completed`.


## 3.3 Dispose Subscription

Khi một `Observable được tạo ra, nó sẽ không hoạt động hay hành động gì cho tới khi có 1 subscriber đăng ký tới`. Việc `subscriber` khi đăng ký tới thì gọi là sub`scription. Lúc đó, sẽ kích hoạt `Observable` (hay gọi là trigger) bắn đi các giá trị của mình. Việc này cứ lặp đi lặp lại, cho đến khi phát ra `.error hoặc .completed.`

- Vấn đề chính bắt đầu từ đây. Ta không bao giờ biết lúc nào nó kết thúc hoặc ta phó mặc nó với số phận. Khi ta chấp nhận buông tay thì hậu quả để lại là các đối tượng trong chương trình của ta không bao giờ bị giải phóng. Và bạn không biết khi nào dữ liệu tới hoặc de-bugs để biết lỗi từ đâu mà ra.

```swift
let observable = Observable<String>.of("A", "B", "C", "D", "E", "F")
    
let subscription = observable.subscribe { event in
    print(event)
}
```

Ta có một đoạn code với việc khai báo 1 `Observable` với kiểu dữ liệu Output là String. Tiếp sau đó, tạo thêm 1 `subscription` bằng việc sử dụng toán tử `.subscribe cho Observable`. Cung cấp thêm 1 closure để handle các dữ liệu nhận được.

Tiếp theo, để dừng việc phát của Observable thì ta sử dụng hàm `.dispose()`:

```swift
subscription.dispose()
```


## 3.4 DisposeBag

Câu chuyện vẫn còn vui, bạn xem tiếp ví dụ code sau:

```swift
Observable<String>.of("A", "B", "C", "D", "E", "F")
        .subscribe { event in
            print(event)
        }
```

Nếu như bạn tạo ra 1 `subscription` để quản lý các đăng ký. Thì mọi thứ đơn giản rồi. Tuy nhiên vẫn là câu nói cũ Đời không như là mơ. Thường trong code Rx thì:
- Các đối tượng `subscriber` hầu như không tồn tại hoặc không tạo ra.
- Các `subscription` sẽ được tạo ra nhằm giữ kết nối. Nó sẽ phục vụ cho tới khi nào class chứa nó bị giải phóng.
- Có quá nhiều `subscription` trong một class.
- Nhiều trường hợp muốn `subscribe` nhanh tới 1 `Observable` nên các `subscription` sẽ không tạo ra.

Vậy là, vấn đề bộ nhớ vẫn nhức nhói. Do đó, người ta sinh ra khái niệm mới `DisposeBag` (túi rác quốc dân). Bạn xem tiếp code ví dụ trên với việc thêm `DisposeBag` vào:

```swift
let bag = DisposeBag()

Observable<String>.of("A", "B", "C", "D", "E", "F")
    .subscribe { event in
        print(event)
    }
    .disposed(by: bag)
```

Lúc này, bạn không cần bận tâm lắm về `Observable` mình tự do làm càng. Tất cả sẽ được `disposeBag` quản lý và thủ tiêu. Áp dụng vào trong `project`, khi bạn khai báo 1 `disposeBag` là biến toàn cục. Khi đó, bạn chỉ cần ném tất cả các `subscription` hoặc các `Observable` vào đó. Và yên tâm về vấn đề bộ nhớ sẽ không bị ảnh hưởng.










# V.Reference

1. [RxSwift-FxStudio](https://fxstudio.dev/rxswift-observables/)