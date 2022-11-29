## 项目结构
项目的核心代码在 **src/main** 目录下，在这个目录下只需要关注两个文件夹：**java/de.neemann/digiblock** 和 **resources** 文件夹。

**java/de.neemann/digiblock** 是核心代码的实现;   
**resources** 是所需的资源文件放置的地方（比方说导出 verilog 的模板文件就放在这里）。 

## java/de.neemann/digiblock
**plugin** 文件夹下放置了要添加的IP核，lattice目录下是lattice中的，如果是别的类型的，可在plugin下新建一个目录。
+ `PluginFun` 类放置了一些公共方法
+ `PluginKeys` 类用于定义定义新添加的属性，所有新添加的属性都放在该类下 

### 定义行为逻辑
以 PLL 为例，
+ 要创建一个IP核，需要先创建对应的构造类
  + 在类所在的目录，ctrl+N（反正是新建，mac 是command+N，我猜Windows的应该是ctrl+N），弹框中选择 Java Class，输入类名，会自动创建文件和对应的类
  + 在创建好的类中，参照 `PLL` 类，添加 `extends Node implements Element`，表示对`Node`类的继承和`Element`接口的实现（所有的代码都不建议直接复制粘贴上去，通过idea的智能提示来补充，因为idea会自动引入这些类，否则会报红，要自己添加这些引用）
    ```java
    public class PLL extends Node implements Element {
    }
    ```
  + 这个时候会报红，把鼠标放到报红的地方（也就是类声明的地方，上面的示例代码的位置），会有一个提示，点击提示中的"implement methods"，会弹出一个对话框，直接ok，就会自动补全要完善的方法
+ `DESCRIPTION`：定义IP核的**输入端口**和**属性**
  ```java
  public class PLL extends Node implements Element {
      public static final ElementTypeDescription DESCRIPTION = new ElementTypeDescription(PLL.class,
            input("CLKI", ""))
            .addAttribute(Keys.ROTATE)
            .addAttribute(Keys.LABEL);
  }
  ```
  + 按照上述代码定义 `DESCRIPTION`，把 `IPCore.class` 换成自己的IP核的类的 `.class`
  + `input(a, b)` 定义输入端口，参数 a 是端口名，现在在UI上的，参数 b 是对端口的描述，可缺省；如果有多个输入端口，则多个 `input` 之间逗号隔开，可参考其它IP核的定义
  + `.addAttribute(a)` 定义属性，要传递的参数是已经定义好的关键词常量；`Keys` 是原本定义好的属性类，在"Keys"文件中；如果需要添加Keys中没有的属性，建议添加在 `PluginKeys` 中
  + 如果需要添加位宽的属性定义，参考 LRamDP
+ 变量定义
  ```java
  public class PLL extends Node implements Element {  
      // label 变量
      private final String label;
        
      // 输入端口变量
      private ObservableValue clkI;
        
      // 输出端口变量
      private ObservableValue clkOp;
        
      // 中间变量（根据情况决定是否需要）
      private long outValue;
  }
  ```  
  + 输入/输出端口变量，必须是 `ObservableValue` 类型（不要复制！）
+ 实例化构造类，创建一个与类名一样的方法：构造方法，并且传递参数 `ElementAttributes attributes`
  ```java
  public class PLL extends Node implements Element {  
      public PLL(ElementAttributes attributes) {
          label = attributes.getLabel();
          clkOp = new ObservableValue("CLKOP", 1).setPinDescription(DESCRIPTION);
      }
  }
  ``` 
  + 赋值 label
  + **定义输出端口**：输出端口的定义是在构造方法中。通过实例化`ObservableValue`类实现，参考 PLL 的 CLKOP 来定义即可
+ `readInputs()`：读输入端口的值
+ `writeOutputs()`：写输出端口的值
+ `setInputs()`：设置输入端口
  ```java
  public class PLL extends Node implements Element {  
      public void setInputs(ObservableValues inputs) throws NodeException {
          this.clkI = inputs.get(0).addObserverToValue(this).checkBits(1, this);
      }
  }
  ```
  + `inputs.get(n)` 中的这个 n 跟 `DESCRIPTION` 中定义输入端口的顺序有关，所以有多个输入端口的时候，需要注意一下
+ `getOutputs()`：返回输出端口列表

### 注册IP组件
在 `ElementLibrary` 类中（连按shift键查找打开），`ElementLibrary` 构造方法中注册新建的IP类
+ 在 `root` 变量最后，添加了 ip 作为一级目录，新的系列可在 `.add(new LibraryNode(Lang.get("lib_lattice")))` 后添加新的二级目录（为了防止还要添加 lattice 的其它系列，所以添加了 machXO2 作为三级目录）
+ 具体的组件一定要在所属目录中添加，即注意括号的匹配，通过 `.add(IPCore.DESCRIPTION)`添加新创建的IP
+ `Lang.get("lib_machXO2")` 这个是在配置文件中写好的，如果不想那么麻烦，也可以直接传个字符串
  + 在 **lang_en.xml** 文件中（连按shift查找打开），可以 ctrl+f 查找 `lib_machXO2`，然后在它下面对照着写一个自己取的目录名即可

### 定义IP组件的样式
在 `ShapeFactory` 类的构造函数 `ShapeFactory` 中，为新建的IP组件添加样式。
+ `map.put()` 拉到后面，会看到定义了 lattice 的组件的地方，直接在 PLL 后面对照着添加即可

## resources/verilog
导出 verilog 的模板文件就放在该目录下，命名必须是 `DIG_` 开头，而且后接与定义的IP构造类名一致。

如果只是纯粹导出，直接复制粘贴 DIG_PLL.v 的内容即可

## 导出inout端口
###设置inout类型输出端口
在IP核的构造类的构造函数中，创建输出端口时，在最后添加 `.setBidirectional()` 方法。
```java
public class PLL extends Node implements Element {  
    public PLL(ElementAttributes attributes) {
        // 一般的 output 的定义
        clkOp = new ObservableValue("CLKOP", 1).setPinDescription(DESCRIPTION);
        // inout 的定义，在原基础上添加 .setBidirectional()
        clkOp = new ObservableValue("CLKOP", 1).setPinDescription(DESCRIPTION).setBidirectional();
    
    }
}
```
###导出时添加inout支持
在 `HDLModel` 类的 `addInputsOutputs()` 方法，即 187 行的 `if` 语句中，添加所创建的IP的构造类的描述
```java
public class HDLModel {  
    private addInputsOutputs() {
        // 一般的 output 的定义
        case both:
            // 在 if 中多添加创建的IP的构造类的 DESCRIPTION
            if (v.equalsDescription(PinControl.DESCRIPTION) || v.equalsDescription(PLL.DESCRIPTION)) {
                // ...
            }
    }
}
```
