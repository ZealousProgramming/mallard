
## Autolayout
- Elements need a minimum size vector
  - Elements shouldn't be able to shrink smaller than the set minimum size
  - The layout container will take the min_size of the largest min_size of it's immediate chilren or it's own min_size
- Other layout options should control how the element acts outside the bounds of the minimum size
- Layout can have a spacing property to edit the spacing in between children

``` go
Mallard_Sizing_Behavior :: enum {
	Fill, // Fills the available space without affecting other elements
	Begin, // Align with container start, and only fill the minimum size of the element
	Center, // Align with container center, and only fill the minimum size of the element
	End, // Align with container end, and only fill the minimum size of the element
}

// Example layout for a min_size of 2 blocks
// [ ][ ][ ][ ]
// -- Fill
// [x][x][x][x]
// -- Begin
// [x][x][ ][ ]
// -- Center
// [ ][x][x][ ]
// -- End
// [ ][ ][x][x]
```
