# JsTypeHax

Wii U browser exploit for system version 5.5.x (5.5.1 and 5.5.3 has been tested,
but any 5.5.x should work).  

The exploit may even work on older versions, but this has not been tested yet.

# Usage

Requires a valid payload (`"code550.bin"`) in the root dir and the release files
from the [wiiuhaxx_common repo](https://github.com/wiiu-env/wiiuhaxx_common/releases)
inside a subfolder called `"wiiuhaxx_common"`.  

The environment after getting code execution is **very** fragile. It's recommended
to use the [JsTypeHax_payload](https://github.com/wiiu-env/JsTypeHax_payload) to
get into a limited, but stable one.

# Useful tips

- **Make sure to run the exploit via an link (like the `index.php`), visiting
the exploit page (`index-hax.php`) directly may fail.**  
- If you have any issues, try to reset your browser save data.
- Don't visit any other pages before doing the exploit (open browser -> open
  index.php -> click on "HAXX")

# Requirements
A webserver with php support.

# The bug

`CVE-2013-2857`, Use after free https://bugs.chromium.org/p/chromium/issues/detail?id=240124 .

# Credits

- JumpCallPop, jam1garner, hedgeberg: Inital exploit
- yellows8: ROP
- orboditilt: increasing stability
