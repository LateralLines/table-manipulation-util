# table-manipulation-util
 A utility for performing common table operations with metamethods. Refer here for more info --> https://devforum.roblox.com/t/open-source-table-manipulation-utility/611377

### Disclamer
The current version (0.1) is in no way well optimized or ready for professional work of any sort. This version is not stable and should only be used for preliminary or experimental development. A stable pre-alpha/alpha version will be distrubuted within a week. For now, use at your own discretion.

# Installation

METHOD #1: From roblox.com -- https://www.roblox.com/library/5136940156/Table-Manipulation-Utility

METHOD #2: Directly from Source.lua -- https://github.com/LateralLines/table-manipulation-util/blob/master/Source.lua

# Usage
### Special cases

**Negative index**
In every operation that involves providing an index value, a negative integer will represent the index position offset from the end of an ordinal table, going right to left. In other words, if i < 0 then the true index is #table + i + 1 (i must be nonzero as well).

**Chaining**
For all invocation operations, the table being invoked will be returned (except when the table has being cloned). Hence, an assignment statement is usually unnecessary as everything can be written in one expression. Additionally, negation (-), modulus (%), and exponentiation (^) will return different tables with the same custom metamethods attached to them. All returned table(s) will include such metadata, with the exception of `util()` (see below).

### Initialization
Simply require the the module and call the associated function like so:


`table util ()` -- Returns a blank table with the appropriate metamethods

`table util (table tab)` -- Returns tab with the appropriate metamethods attached

`table util (table tab, bool removeMeta)` -- If true, removeMeta will remove all of tab's metadata

`table util (int count, Variant value)` -- Initializes a table of values, where the amount is specified by count, and attaches appropriate metamethods (equivalent to table.create)

### Duplication
`table tab()` -- Returns a shallow copy

`table tab{}` -- Returns a deep copy
~~~lua
original = util {1, {}, 3}
shallow = original()
deep = original {}

print (original[2] == shallow[2]) --> true
print (original[2] == deep[2]) --> false
~~~

### Concatenation
`string table .. (string sep)` -- Converts ordinal elements of a table into a string separated by sep (equivalent to table.concat)
~~~lua
print (util {1, 2, 3} .. ', ') --> '1, 2, 3'
~~~

### Insertion

`self table (Variant value)` -- Inserts a non-nil value at index #table + 1 (equivalent to table.insert)

`self table (Variant value, int index)`  -- Inserts a non-nil value at index (also equivalent to table.insert)
~~~lua
tab = util {1, 2, 3}
tab (0, 1) --Inserts at beginning
tab (4) --Inserts at end
print (tab .. ', ') --> '0, 1, 2, 3, 4'
~~~

### Deletion
`self table (nil)` -- Removes the value at index #table + 1 (equivalent to table.remove)

`self table (nil, int index)` -- Removes the value at index (also equivalent to table.remove)
~~~lua
tab = util {1, 2, 3}
tab (nil) --Deletes element at end
tab (nil, 1) --Deletes first element
print (tab .. ', ') --> '2'
~~~

### Batch Operations
`self table (Variant value, table indices, bool shift)` -- Takes a table of indices and either directly assigns them if shift is true or inserts them into the table if shift is false or left omitted

`self table (nil, table indices, bool shift)` -- Takes a table of indices and either assigns the corresponding indices to nil if shift is true or removes them if shift if false or left omitted
~~~lua
tab = util ()
tab (true, {'Frame', 'ScrollingFrame'})
tab (nil, {'Frame'})
~~~
**NOTE #1** - Non-numeric elements indices will always be directly assigned to value in both insertion and deletion operations regardless shift

**NOTE #2** - Be careful not to accidentally insert a single table instead of inserting the elements themselves; you must supply at least 3 arguments for a batch operation to occur.

`self table (table t1, int start, int stop, int index, bool shift)` -- Takes table t1, cropped by start and stop, and either appends it to the table if shift is true or replaces it into the table being invoked (equivalent to table.move) if shift is false or left omitted. int index defaults to 1.
~~~lua
tab1 = util {1, 4}
tab2 = util {2, 3}
tab1 (tab2, 1, 2, 2, true) --> {1, 2, 3, 4}
~~~

`self table (table elements)` -- Assigns the corresponding key, value pairs within elements to the table being invoked (**does not** shift ordinal elements)
~~~lua
tokens = util {}
tokens {
   Player1 = 5,
   Player2 = 2,
   Player3 = 10
}
~~~

`table tab ^ {int start, int stop}` -- Returns a range of values from tab (similar to table.move)
~~~lua
tab = util {5, 6, 7, 8}
range1 = tab ^ {2, -1} --> {6, 7, 8}
range2 = tab ^ {3} --> {7, 8}
~~~

### Searches
`table tab % {Variant value, bool global}` -- Performs a sequential search and returns a table of index matches (if none were found, the table will be empty). If global is true, the search will record all occurrences -- otherwise it will exit after its first match.
*Deferred: Multiplication & Division for unions & negations*

### Primitive retrieval
`Variant table + int index` -- Indices int index in table

`Variant table - int index` -- Indices int index from the end of the table
~~~lua
tab = util {1, 3, 4}
print(util + 2) --> 3
print(util - 1) --> 4
print(util + -1) --> 4
~~~

### Miscellaneous
`table -tab` --Returns a reversed copy of tab (does not affect dictionary elements)
