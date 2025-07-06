
#  Test de Markdown

**MarkdownView offers a super easy** and highly customizable way to display markdown content in your app.

It leverages swift-markdown to parse markdown content, fully compliant with the CommonMark Spec.

---

## Lists

By creating a culture where everyone takes responsibility for a safe working environment an takes care of themselves and one another, many work-related accidents and incidents can be avoided.

- Test line **One**
- *Second line*

- Nested lists test
    - Sub item One
    - Sub item Two
- Item below nested list

## Task Lists

- [ ] Unchecked task item
- [x] Checked task item
- [ ] Another unchecked item
    - [x] Nested checked item
    - [ ] Nested unchecked item
- Regular item without checkbox

---

## Ordered Lists

1. Item One
2. Item Two
    1. Test nested orderer list
    2. Second sub item

***

## Long styled paragraphs in list

- **Long item rendered in list**: Seafarers, like shore workers, have the right and expectation that they will remain safe at work. 
- The Company and employers have a responsibility to ensure the health, safety and welfare at work of all seafarers and other workers on board. 
- Seafarers have a duty to take reasonable care for the occupational health and safety of themselves and others, and to cooperate with their employer and the Company in matters of health, safety and welfare.

___

## Table

| Table Header | Col Two     |
| ------------ | ----------- |
| Col_1 Row_A  | Col_2 Row_A |
| Col_1 Row_B  | Col_2 Row_B |

- - -

## Code

### Swift
```swift
// Swift example with syntax highlighting
struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
                .font(.largeTitle)
            
            Button("Increment") {
                count += 1
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

### Python
```python
# Python example with syntax highlighting
def fibonacci(n):
    """Generate Fibonacci sequence up to n terms"""
    fib_sequence = [0, 1]
    
    for i in range(2, n):
        next_num = fib_sequence[i-1] + fib_sequence[i-2]
        fib_sequence.append(next_num)
    
    return fib_sequence[:n]

# Example usage
print(fibonacci(10))
```

### JavaScript
```javascript
// JavaScript example with syntax highlighting
class Calculator {
    constructor() {
        this.result = 0;
    }
    
    add(value) {
        this.result += value;
        return this;
    }
    
    multiply(value) {
        this.result *= value;
        return this;
    }
    
    getResult() {
        return this.result;
    }
}

// Example usage
const calc = new Calculator();
console.log(calc.add(5).multiply(3).getResult()); // 15
```

### Ruby
```ruby
# Ruby example
class Person
  attr_accessor :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
  
  def greet
    puts "Hello, my name is #{@name} and I'm #{@age} years old."
  end
end

person = Person.new("Alice", 30)
person.greet
```

### Java
```java
// Java example
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
        
        // Example of a simple loop
        for (int i = 0; i < 5; i++) {
            System.out.println("Iteration: " + i);
        }
    }
}
```

### Inline Code
You can also use inline code like `let x = 42` or `print("Hello")` within paragraphs.

* * *

## Blockquote

> By creating a culture where everyone takes responsibility for a safe working environment an takes care of themselves and one another, many work-related accidents and incidents can be avoided.

_ _ _

## Horizontal Rules Examples

### Different styles of horizontal rules:

Three hyphens:
---

Three asterisks:
***

Three underscores:
___

With spaces between:
- - -

* * *

_ _ _

## Rule

Seafarers, like shore workers, have the right and expectation that they will remain safe at work. The Company and employers have a responsibility to ensure the health, safety and welfare at work of all seafarers and other workers on board. Seafarers have a duty to take reasonable care for the occupational health and safety of themselves and others, and to cooperate with their employer and the Company in matters of health, safety and welfare.

By creating a culture where everyone takes responsibility for a safe working environment an takes care of themselves and one another, many work-related accidents and incidents can be avoided.

## Download

The latest version of the Code of safe working practices for merchant seafarers (COSWP) can be downloaded [Here](https://www.gov.uk/government/publications/code-of-safe-working-practices-for-merchant-seafarers-coswp-2024)

| **Version** | **Date**      | **Editor**        | **Revision History** |
| ----------- | ------------- | ----------        | -------------------- |
| 1.0         | 07 March 2025 | Christophe Guegan | Initial Commit       |
| 1.1         | 17 June 2025  | Christophe Guegan | Cleanup Writing      |


## Image

![Unsplash](https://images.unsplash.com/photo-1750688650545-d9e2a060dfe8?q=80&w=3206&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)
