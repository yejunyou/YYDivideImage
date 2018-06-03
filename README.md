- 纯Swift
- 一款能把图像均匀分割成小图的工具
- 常用于发朋友圈前把1张大图分成9张小图，或者把全景图分成3张小图，也支持**自定义行列数**分割
- 支持原图分割（目前市面上分割工具皆有截取，会造成部分图像信息丢）
  - 也可以理解为: 截取为正方形是为了发朋友圈的图片不拉伸变形
  - 但是经过验证，发现1行 X 3列 或者 2行 X 3列的时候，原图分割是更贴近**还原度**和**视觉审美**的
  - 综上，是否截取这个选择应该交给用户决定

