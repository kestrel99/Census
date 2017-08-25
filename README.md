# Census
A (now rather old-fashioned) run manager for NONMEM.

v. 2.9 (25/08/2017)
Justin Wilkins (justin.wilkins@occams.com)

NONMEM is an extremely powerful tool for nonlinear mixed-effect modelling and simulation of pharmacokinetic and pharmacodynamic data. However, it is a console-based application whose output does not lend itself to rapid interpretation or efficient management. Census has been created to be a comprehensive project manager for NONMEM, providing detailed summary, comparison and overview of the runs comprising a given project, including the display of output data, simple post-run processing, fast diagnostic plots and run output management, complementary to other available modelling aids. Analysis time ought not to be spent on trivial tasks, and Census's role is to eliminate these as far as possible by increasing the efficiency of the modelling process. 

Census 2 is a complete rewrite of the original Delphi codebase, migrating the development environment to free Delphi substitute Lazarus, and focusing on support for NONMEM 7.2 or better.

Census 2 is made available under the GNU Lesser General Public License (LGPL), version 3.0. 

## Installation

Windows: Run the installer.
Mac:     You'll need to compile from source. 

## Compiling from source

You will need:

Lazarus 1.6.4 (or better) with FPC 3.0.2 (or better), free from http://www.lazarus.freepascal.org, with the following components installed (all included in the GitHub repo):

* History Files 1.2.1 - http://www.andrearusso.it
* JFCBrkApart 1.07 - http://cycocrew.pagesperso-orange.fr/delphi/components.html
* Synapse - http://synapse.ararat.cz/ 
* Zeos DBO 7.0.4 - http://zeos.firmos.at
* LazReports - included with Lazarus, but not installed by default

If you find any dependencies not included here, please let me know. 

To generate an executable, install all the above components into the Lazarus IDE, load Census.lpi, and compile. Installation instructions for Lazarus and these libraries are available at the Lazarus website, the component websites, and supplied README files.

## Updates

The most recent version of the source, as well as binary versions for Windows, will always be available from https://github.com/kestrel99/Census.

## Known issues

* Occasional problems importing $OMEGA labels.

