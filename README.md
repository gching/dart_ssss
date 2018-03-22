# dart_ssss 

[![Build Status](https://travis-ci.org/gching/dart_ssss.svg?branch=master)](https://travis-ci.org/gching/dart_ssss)
[![Coverage Status](https://coveralls.io/repos/github/gching/dart_ssss/badge.svg?branch=master)](https://coveralls.io/github/gching/dart_ssss?branch=master)

A Dart library that implements [Shamir's Secret Sharing Scheme](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing) 
over [GF(256)](http://www.cs.utsa.edu/~wagner/laws/FFM.html).

Given a secret in bytes, this package can assist in splitting up the secret into `n` parts and would be able to 
reconstruct the secret in bytes given a `t` threshold.

I would highly recommend you look at the the wikipedia page above to learn about the workings of Shamir's Secret Sharing
Scheme.

## Getting Started

To use `dart_ssss`, add it to your dependencies in `pubspec.yaml`:

```
dependencies:
    dart_ssss: any
```

Then import the proper package:

```
import 'package:dart_ssss/dart_ssss.dart';
```


## Usage 

To generate shares / parts for a secret of bytes:

```
void main() {
    
    List<int> secretInByteValues = [...];
    
    SecretScheme ss = new SecretScheme(numberOfPartsToGenerate, thresholdForJoining);
    
    Map<int, List<int>> shares = ss.createShares(secretInByteValues);
    
    ...
      
     
```

To combine shares to regenerate a secret:

```
    List<int> recombinedSecretInBytes = ss.combineShares(shares);
}
```

## Tests

To run tests on this package:

```
    pub run test 
```

in the package directory.


## Limitations / Caveats

Given that the package is implemented over GF(256), it means that the max number of shares / parts it can generate is 
`255`. With that said, it is not advisable to generate `255` shares / parts as an adversary can 
[forge a secret](https://crypto.stackexchange.com/questions/54578/how-to-forge-a-shamir-secret-share).    

Shamir's Secret Sharing Scheme does not guarantee integrity, so if you are looking for something where you can verify
shares or the resulting secret, this package is not for you.

## License

Copyright 2018 Gavin Ching

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

