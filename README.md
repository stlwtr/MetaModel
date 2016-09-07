![MetaModel-banner](./images/banner.png)

# MetaModel

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/draveness/metamodel/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/metamodel.svg?style=flat)](http://rubygems.org/gems/metamodel)

MetaModel is an iOS framework designed to help developer to deal with data persistent, JSON to model constructor and a bunch of APIs which provides an approach of handling client side database very easily.

> MetaModel is under-development, API may constantly change before gets to 1.0.0.

+ [x] Fastest JSON to model API
+ [x] Dealing with database without writing SQL
+ [x] Most concise API to retrieve data from persistent level

MetaModel provides convenience chainable APIs to manipulate models like ActiveRecord.

```swift
let json = ["id": 1, "name": "Buzz", "email": "i@metamodel.info"]
let person = Person.parse(json)

// INSERT INTO "people" (id, name, email) VALUES (1, "Buzz", "i@metamodel.info")
person.save

// SELECT "people".* FROM "people" WHERE "people"."id" = 1 LIMIT 1
if var person = Person.find(1) {
    // UPDATE "people" SET "people"."name") = "Buzz" WHERE "people"."id" = 1
    person.update(name: "Draven")
}

// SELECT "people".* FROM "people"
print(Person.all)
```

## Usage

Use a meta file in `./meta` folder to define your model:

```ruby
define :User do |j|
  # define User model like this
  j.nickname :string
  j.avatar :string
  j.email :string, :unique, default: "default@gmail.com"
end
```

And then run `meta build` will automatically generate all the code you need.

## Installation

```
sudo gem install metamodel --verbose
```

**System Requirements**: Current version of MetaModel requires macOS with Ruby 2.2.2 or above

## Quick Start

After installation , run `meta init` in your iOS project root folder which will make a `meta` directory in current folder.

```shell
$ cd /path/to/project
$ meta init

Initialing MetaModel project

Creating `meta` folder for MetaModel
```

Generate your model meta file with `meta generate`.

```shell
$ meta generate User

Generating model meta file

-> Adding `user.rb` to meta folder

[!] `user.rb` has already generated, use the command below to edit it.

  vim meta/user.rb
```

Edit meta file using vim, Emacs or other editor and run `meta build`.

```shell
$ meta build

Building MetaModel.framework in project
  Existing project `./metamodel/MetaModel.xcodeproj`

Analyzing meta files
  -> Resolving `user.rb`

Generating model files
  -> Using User.swift file

Generating MetaModel.framework
  -> MetaModel.framework located in current folder

[!] Please drag MetaModel.framework into Embedded Binaries phrase.
```

This command build a `MetaModel.framework` in project root folder, you need to add this framework to **Embedded Binaries** phrase which located in `General` tab.

![integrate-metamodel-framework](images/integrate-metamodel-framework.png)

Add this line of code in your project.

```swift
import MetaModel
```

![import-metamodel-module](images/import-metamodel-module.png)

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](./LICENSE) file.

The MIT License (MIT)

Copyright (c) 2016 Draveness

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
