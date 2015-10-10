# Package

## Introduction
Package is a linux script which collects the dependent libraries of a binary program file and generates an green installer of the program.

## Installation
Clone or download a copy of this project. Copy the project directory to your preffered directory then set PACHAGE_HOME and PATH in /etc/profile, ~/.bash_profile or ~/.vimrc as you want.
```bash
cp -R . /opt/package 
export PACKAGE_HOME=/opt/package
export PATH=$PACKAGE_HOME:$PATH
```

## Usage
Make an installer of a binary_file:
```bash
package binary_file installer_directory
```
Install the program:
```bash
cd installer_directory
./install
```
Uninstall the program:
```bash
cd installer_directory
./uninstall
```
You can also uninstall the program by yourself by deleting all the files you have installed into the install_directory specified when you run the ./install script and the binary_file.desktop file in the ~/Desktop directory.

## Notices
If your binary_file have extra dependent files, for example a Qt program may need qml files, you must copy these extra files into installer_directory/software before run the ./install script.

## License
    Copyright 2015 NTU (http://www.ntu.edu.sg/)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
