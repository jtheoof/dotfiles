# TagHighlight

TagHighlight is a plugin that highlights names of classes, variables, types etc in source code in Vim.  This makes it quicker and easier to spot errors in your code.  By using exuberant ctags and parsing the output, the typedefs, #defines, enumerated names etc are all clearly highlighted in different colours.  As standard, it supports the following languages (but it's very easy to add more):

* C/C++ (most of the testing has been with these)
* C#
* Java
* Javascript
* Matlab (functions only; may require custom ctags version)
* Perl
* PHP
* Python
* Ruby
* Scala
* Fortran
* Go (if your version of ctags supports it)
* VHDL (if your version of ctags supports it)

Adding more languages is extremely simple.

To show the benefit of this plugin, there are some screenshots and a more detailed description at the following website:

  [http://www.cgtk.co.uk/taghighlight][Website]

Installation instructions are available here:

  [http://www.cgtk.co.uk/taghighlight/install][InstallGuide]

The source is managed in Mercurial and is available on [bitbucket][Bitbucket].

Detailed documentation can be found in [doc/TagHighlight.txt][Documentation].

[Website]: http://www.cgtk.co.uk/taghighlight
[InstallGuide]: http://www.cgtk.co.uk/taghighlight/install
[Bitbucket]: https://bitbucket.org/abudden/taghighlight
[Documentation]: https://bitbucket.org/abudden/taghighlight/src/default/doc/TagHighlight.txt
