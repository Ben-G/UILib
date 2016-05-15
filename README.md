# UILib

UILib brings the concepts of Facebook's React to Swift and UIKit.

##Goals

- Make library as uninvasive as possible: make it use system components; make it easy to use with existing UI components
- Use native UI APIs on the rendering layer to get full functionality of complex UI components, such as table views and collection views

##Technical Details

Using UILib views are represented as a tree of components. There are two types of components: `Component` and `ContainerComponent`.

Each Component renders itself.