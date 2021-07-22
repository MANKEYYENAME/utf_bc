| module name      | info                                                         |
| ---------------- | ------------------------------------------------------------ |
| `utf_bc.package` | lazy decoding - `decode`, encoding with custom allocator - `encode`, converting - 'convert', get char - `charAt`, chars count - `codePointsCount` |
| `utf_bc.formats` | some enumerations, and help functions                        |
| `utf_bc.le_be`   | Some utils for working with endians                          |
| `utf_bc.utils`   | Some utils                                                   |
| `utf_bc.ascii`   | ASCII encoding, decoding                                     |
| `utf_bc.utf8`    | UTF-8 encoding, decoding                                     |
| `utf_bc.utf16`   | UTF-16LE & UTF-16BE encoding, decoding                       |
| `utf_bc.utf32`   | UTF-32LE & UTF-32BE encoding, decoding                       |
| `utf_bc.ucs2`    | UCS-2LE & UCS-2BE. legacy format, only holds 2 ^ 16 characters |

`codeLength!(format)`- get the number of bytes that a character takes in the format. Accepts `dchar`, or the first `char` or ` wchar` of a character.

`decodeChar!(format)(4 bytes of data, ref FormatError)`- decode a character from 4 bytes of data.

`encodeChar!(format)(dchar, ref FormatError)`- encode a character to 4 bytes of data.



Specify false in the template parameter `check_size` in` decode`, `convert` to speed up decoding if the number of bytes in the line is a multiple of 4.