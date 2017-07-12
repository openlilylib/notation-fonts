openLilyLib/notation-fonts
===========

A package to manage font selection with the [GNU LilyPond](http://lilypond.org) music typesetter.
This repository is part of [openLilyLib](https://github.com/openlilylib/openlilylib) and maintained by

- Urs Liska (ul@openlilylib.org)
- Kieren MacMillan (kieren_macmillan@sympatico.ca)
- Abraham Lee (tisimst.lilypond@gmail.com)

---

This package builds on the possibility to choose alternative notation fonts that has been added to GNU LilyPond 
with version 2.19.12. Basically the package provides a convenience layer to

* easily load a notation font
* automatically load a default stylesheet together with the font
* optionally load an extension stylesheet to access specific features of a font.

**Note:** The fonts are *not* included in this package.

Using Alternative Fonts
-----------------------

The easiest way to use an alternative notation font in LilyPond is:

```lilypond
\version "2.19.12"

% load openLilyLib
\include "oll-core/package.ily"
% load this package
\loadPackage notation-fonts
\useNotationFont Cadence
```

which will set up everything correctly to use "Cadence" as your document's notation font.
Font names are case insensitive (so other than with the manual activation you don't need to
write `cadence` here, and note that when the font name doesn't contain "illegal" characters
(which currently only is the case with `Gutenberg1939`) you don't need quotation marks.

The “simple” form of `\useNotationFont` uses the same name for notation and brace fonts and loads
a default stylesheet that accompanies each font, adjusting LilyPond's engraving settings (e.g.
line thicknesses) to match the appearance of the font. However, you have more fine-grained control
by using the following form:

```lilypond
\useNotationFont \with {
  brace = Beethoven
  style = none
  extensions = ##t
}
Cadence
```

This will set the brace font to `Beethoven` and skip loading of a stylesheet. Using `none` for the
`brace` option will use the default Emmentaler brace font, which is usually a good idea when the
notation font does not have a corresponding brace font (which is currently the case with the 
*Cadence*, *Paganini* and *Scorlatti* fonts).

Using `none` as `style` will skip loading a stylesheet, which you may want when creating a style sheet
from scratch. Please consult the documentation about any additional styles available for a given font.
if a non-existent stylesheet is requested a warning is issued and the default stylesheet is loaded.

Requesting a notation font or (even implicitly) a brace font that is not available for the given
backend in the executed LilyPond installation will issue a warning and reset the (brace) font to
*Emmentaler*, but LilyPond errors are avoided.

A font may contain extensions that can be activated with the `extensions = ##t` option. Currently only
the *Arnold* fonts has such extensions, consisting of a few extra articulations and commands.
Requesting extensions for a font that doesn't provide them will issue a warning but don't do any further harm.
