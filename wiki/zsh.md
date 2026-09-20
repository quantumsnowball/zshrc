# 🚀 Zsh Conditional Expressions Cheatsheet

Always use `[[ ... ]]` instead of `[ ... ]` or `test` in Zsh.
It is safer, more powerful, and does not require quoting variables to prevent word splitting.

---

## 📂 File Conditionals

| Format | Returns True If... |
| :--- | :--- |
| `[[ -e file ]]` | `file` **exists** (any type). |
| `[[ -a file ]]` | `file` **exists** (same as `-e`). |
| `[[ -f file ]]` | `file` exists and is a **regular file**. |
| `[[ -d file ]]` | `file` exists and is a **directory**. |
| `[[ -s file ]]` | `file` exists and has a **size greater than zero** (not empty). |
| `[[ -h file ]]` | `file` exists and is a **symbolic link**. |
| `[[ -L file ]]` | `file` exists and is a **symbolic link** (same as `-h`). |
| `[[ -r file ]]` | `file` exists and is **readable** by you. |
| `[[ -w file ]]` | `file` exists and is **writable** by you. |
| `[[ -x file ]]` | `file` exists and is **executable** by you. |
| `[[ -p file ]]` | `file` exists and is a **FIFO** (named pipe). |
| `[[ -S file ]]` | `file` exists and is a **socket**. |
| `[[ -b file ]]` | `file` exists and is a **block special file**. |
| `[[ -c file ]]` | `file` exists and is a **character special file**. |
| `[[ -g file ]]` | `file` exists and has its **set-group-ID** bit set. |
| `[[ -u file ]]` | `file` exists and has its **set-user-ID** bit set. |
| `[[ -k file ]]` | `file` exists and has its **sticky bit** set. |
| `[[ -O file ]]` | `file` exists and is **owned** by your effective user ID. |
| `[[ -G file ]]` | `file` exists and its group matches your effective **group ID**. |
| `[[ -N file ]]` | `file` exists and its **access time is not newer than modification time**. |
| `[[ f1 -nt f2 ]]` | `file1` is **newer than** `file2` (or `file1` exists and `file2` does not). |
| `[[ f1 -ot f2 ]]` | `file1` is **older than** `file2` (or `file2` exists and `file1` does not). |
| `[[ f1 -ef f2 ]]` | `file1` and `file2` point to the **same device and inode** (hard links). |

---

## 🔤 String & Pattern Conditionals

Inside `[[ ]]`, the right-hand side string of `=` or `==` treats characters like `*` or `?` as wildcard patterns unless they are quoted.

| Format | Returns True If... |
| :--- | :--- |
| `[[ -z str ]]` | Length of `str` is **zero** (empty string). |
| `[[ -n str ]]` | Length of `str` is **non-zero** (not empty). |
| `[[ str ]]` | `str` is **not empty** (shorthand evaluate). |
| `[[ s1 = s2 ]]` | Strings are **equal** (supports patterns on `s2`). |
| `[[ s1 == s2 ]]` | Strings are **equal** (identical to `=`). |
| `[[ s1 != s2 ]]` | Strings are **not equal**. |
| `[[ s1 < s2 ]]` | `s1` sorts **before** `s2` lexicographically. |
| `[[ s1 > s2 ]]` | `s1` sorts **after** `s2` lexicographically. |
| `[[ s =~ regex ]]` | `s` matches the **regular expression** `regex`. |

---

## 🔢 Numerical Comparisons

> 💡 *Tip: For purely numerical logic, using native arithmetic evaluation like `(( x > y ))` is usually preferred over `[[ x -gt y ]]` in Zsh.*

| Format | Returns True If... |
| :--- | :--- |
| `[[ e1 -eq e2 ]]` | Expression 1 is **equal** to Expression 2. |
| `[[ e1 -ne e2 ]]` | Expression 1 is **not equal** to Expression 2. |
| `[[ e1 -lt e2 ]]` | Expression 1 is **less than** Expression 2. |
| `[[ e1 -le e2 ]]` | Expression 1 is **less than or equal** to Expression 2. |
| `[[ e1 -gt e2 ]]` | Expression 1 is **greater than** Expression 2. |
| `[[ e1 -ge e2 ]]` | Expression 1 is **greater than or equal** to Expression 2. |

---

## ⚙️ Shell Options & Variables

| Format | Returns True If... |
| :--- | :--- |
| `[[ -o opt ]]` | The shell option `opt` is **on/enabled**. |
| `[[ -v var ]]` | The variable `var` is **set** (available in zsh 5.3+). |

---

## 🧩 Combining Expressions (Logical Operators)

| Operator | Usage | Description |
| :--- | :--- | :--- |
| `!` | `[[ ! expr ]]` | **NOT** (Inverts the result). |
| `&&` | `[[ expr1 && expr2 ]]` | **AND** (True if both are true). |
| `\|\|` | `[[ expr1 \|\| expr2 ]]` | **OR** (True if either is true). |
| `( )` | `[[ (expr1 \|\| expr2) && expr3 ]]` | **Group** expressions to override precedence. |



## Common Checks Examples

- Check if a string is empty or not defined	
    ```zsh
    if [[ -z $VARNAME ]];
    ```

- Check if a string is defined and not empty
    ```zsh
    if [[ -n $VARNAME ]];
    ```

- Check if a file exists
    ```zsh
    if [[ -e "filepath" ]];
    ```

- Check if a file exists and is a regular file
    ```zsh
    if [[ -f "filepath" ]];
    ```

- Check if a directory exists
    ```zsh
    if [[ -d "dirpath" ]]; 
    ```

- Check if a symbolic link exists
    ```zsh
    if [[ -L "symlinkpath" ]];
    # or
    if [[ -h "symlinkpath" ]];
    ```

- Check if a shell option is set
    ```zsh
    if [[ -o OPTION_NAME ]];
    ```

- Check if two values are equal
    ```zsh
    if [[ $VAR1 = $VAR2 ]];
    ```

- Check if two values are different
    ```zsh
    if [[ $VAR1 != $VAR2 ]];
    ```

- Check if a number is greater than another	
    ```zsh
    if (( $VAR1 > $VAR2 ));
    ```

- Check if a number is smaller than another

    ```zsh
    if (( $VAR1 < $VAR2 ));
    ```

- Check if a command exits successfully (exit code 0)
    ```zsh
    if command arg1 arg2 ...
    ```
