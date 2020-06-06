## Version 0.2 [UNSTABLE]
- Cloning and intialization optimizations
- Minor memory improvements
- Added two new operations:

`table tab(nil, {})` -- Clears *all* elements

`table tab(Variant value, {})` -- Replaces all *ordinal* elements with value

- __add and __sub modified to also return dictionary elements
- __tostring removed in favor of __concat

## Version 0.1 (initial release) [UNSTABLE]
- Basic functionality for invocation, mathmetical (+, -, %, ^, -n), *tostring*, and concatenation metamethods
- Table insertion, deletion, replacement, transformation, selection, and duplication
