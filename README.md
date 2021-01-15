# mIRC-NickHighlight
A highlight manager, and highlight log viewer, for mIRC.

---

> Originally submitted to `mircscripts.org` back in 2004, and since updated until 2006.

mIRC provides a fairly basic highlighting system, it can accept single words or phrases, but once you get mentioned somewhere, the highlight is often hard to find.

It was not uncommon to have a limited backscroll (the concept of how much text remains visible in the client), to reduce the memory footprint of the client, or to maintain sanity between a lot of channels, but this made finding a previous highlight even harder.

This plugin provides a simple dialog interface for viewing past mentions, and more complex methods of identifying what patters nto highlight a user for, with the added bonus of ignore-patterns as well, to help negate users or combined phrases from triggering a highlight.

---

## Installation

- Extract all files to any directory, make sure to keep any folder names intact.
- Make sure the `DLL` folder is in the same directoriy as `NickHighlight.mrc`
- Open mIRC and type: `/load -rs <dir>\NickHighlight.mrc`
  (Alternatively, this will search for the file and load it: `//load -rs $findfile(C:,NickHighlight.mrc,1)`, but may e resource intensive )

If you get prompted about running the script, please select "Yes".

Now just right-click and select "NickHighlight" in the popup menu and you're off.

---

## Acknowledgements

This script uses the MDX DLL, created by [`westor`](http://westor.ucoz.com/load/mirc_dlls/mdx/2-1-0-5), to improve custom dialog behaviors, notably the table listview used in the plugin.

---

The script is licensed under GPL-2.0, although mIRC itself uses a proprietary license, and is trialware.

Tou are free to use this script as you see fit, but please do include appropriate crediting whenever applicable.
