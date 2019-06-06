# XCF TTML suite


## Introduction

This repository contains a suite of files designated for use with the
XML Checker Framework (XCF), in order to check TTML subtitle files.

The following files are contained here:
- constraints
- Schematron rules (including helper functions)
- rules config file


## Covered specifications

The following TTML specifications are covered by the present constraints:

- IMSC 1.0 Text profile
- [IMSC 1.0.1](https://www.w3.org/TR/ttml-imsc1.0.1/) Text profile
- [IMSC 1.1](https://www.w3.org/TR/ttml-imsc1.1/) Text profile (Beta state)
- [Netflix (unofficial): Timed Text Style Guide](https://backlothelp.netflix.com/hc/en-us/articles/215758617-Timed-Text-Style-Guide-General-Requirements): General Requirements (as of 2018-09-12)


## Related repositories

The actual XCF itself is contained in the [`xcf` Git repository](https://github.com/IRT-Open-Source/xcf) and
provides necessary helper files.


## Details for specific files

The files are described in more detail here.

### /constraints.xml

Contains an XML representation of all constraints that are checked.
A respective XSD exists in the [`xcf` repository](https://github.com/IRT-Open-Source/xcf).

### /rules.sch

This Schematron file contains the implementation for constraint checks.
For more convenient use it should be converted to an XSLT file using the
[Schematron XSLT contained in the `xcf` repository](https://github.com/IRT-Open-Source/xcf/tree/master/xslt/schematron).

### /irt_functions.xsl

This XSLT file contains further custom functions that are needed for the
implementation of the constraint checks. The functions are used in 
in the `rules.sch` and imported by the compiled Schematron XSLT.

### /rules_config.xml

This XML configuration file contains further properties that are related
to the checked constraints/rules, but affect the actual usage of them.
Currently the config file specifies which specifications from the
constraints file are selected by default. Further properties may be
added in the future. The config file is intended to be used by other
applications that make use of this set of constraints/rules.


## License
The XCF TTML suite offered by Institut für Rundfunktechnik GmbH is
subject to the [MIT license](LICENSE).

In case the source code is modified and re-distributed we would welcome
a short note (please email to open DOT source AT irt.de). This way we
can keep track of opportunities to collaborate and to improve the
project.
