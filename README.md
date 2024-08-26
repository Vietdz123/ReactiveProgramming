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






# V.Reference

1. [RxSwift-FxStudio](https://fxstudio.dev/rxswift-observables/)