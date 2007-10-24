dnl Return a font matching the specified characteristics
dnl
dnl GetFont(`Fixed', `Bold', `Normal', `Tiny')
dnl   ==> -adobe-courier-bold-r-*-*-10-*-*-*-*-*-*-*

dnl The default fixed-width font is adobe-courier, but we can
dnl also support lucidatypewriter (using adobe-courier for italic)
dnl and monotype-courier-new (although underline doesn't work
dnl properly on XFree-4.3 server under Linux)
dnl Default fixed font at work under the exceed serve is dt-application
define(`DefaultFixedFont', `adobe-courier')
ifdef(`VNDR_Hummingbird_Communications_Ltd_', `define(`DefaultFixedFont', `dt-application')')
ifdef(`USE_LUCIDA_FOR_FIXED', `define(`DefaultFixedFont', `b&h-lucidatypewriter')')
ifdef(`USE_MONOTYPE_FOR_FIXED', `define(`DefaultFixedFont', `monotype-courier new')')

dnl The default variable-width font is microsoft-comic sans ms, but
dnl we can also support adobe-helvetica
define(`DefaultProportionalFont', `microsoft-comic sans ms')
ifdef(`VNDR_Hummingbird_Communications_Ltd_', `define(`USE_HELVETICA_FOR_PROPORTIONAL', 1)')
ifdef(`VNDR_The_Cygwin_X_Project', `define(`USE_HELVETICA_FOR_PROPORTIONAL', 1)')
ifdef(`USE_HELVETICA_FOR_PROPORTIONAL', `define(`DefaultProportionalFont', `adobe-helvetica')')
ifdef(`USE_VERDANA_FOR_PROPORTIONAL', `define(`DefaultProportionalFont', `microsoft-verdana')')
ifdef(`USE_GEORGIA_FOR_PROPORTIONAL', `define(`DefaultProportionalFont', `microsoft-georgia')')
ifdef(`SRVR_samwise', `define(`USE_TREBUCHET_FOR_PROPORTIONAL', 1)')
ifdef(`USE_TREBUCHET_FOR_PROPORTIONAL', `define(`DefaultProportionalFont', `microsoft-trebuchet ms')')

dnl lucidatypewrite works well for XTerms because no italic font
dnl is required, but it doesn't work for Emacs, where italics are used
define(`DefaultFixedNotItalicFont', `b&h-lucidatypewriter')

define(`GetCharset', `iso8859-1')

define(`GetFamily',
	`ifelse($1, `Fixed', DefaultFixedFont,
		$1, `Proportional', DefaultProportionalFont,
		$1, `FixedNotItalic', DefaultFixedNotItalicFont, `bogus')')

define(`GetSize',
	`ifelse($2, `Tiny', 10,
		$2, `Small', 12,
		$2, `Medium', 14,
		$2, `Large', 18, `bogus')')

dnl Use oblique, not italic font for adobe-courier
define(`GetSlant',
	`ifelse($1, `b&h-lucidatypewriter', r,
		$2, `Regular', r,
		$2, `Italic', ifelse($1, `adobe-courier', o, i), bogus)')

dnl Mono-width or proportional spacing
define(`GetSpacing',
	`ifelse($1, `Fixed', m, $1, `FixedNotItalic', m, p)')

define(`GetWeight',
	`ifelse($2, `Bold', bold,
		$2, `Normal', medium, `bogus')')

dnl $1  Fixed, Proportional or FixedNotItalilc
dnl $2 - Bold or Normal
dnl $3 - Regular or Italic
dnl $4 - Tiny, Small, Medium or Large
define(`GetFont',
	`-GetFamily($1)-GetWeight(GetFamily($1), $2)-GetSlant(GetFamily($1), $3)-*-*-GetSize(GetFamily($1), $4)-*-*-*-GetSpacing($1)-*-GetCharset')
