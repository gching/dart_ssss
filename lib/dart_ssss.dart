/**
 * dart_ssss.dart
 *
 * Copyright 2018 Gavin Ching
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR I
 * MPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/// # dart_ssss
///
/// ## Getting Started
///
/// To generate shares / parts for a secret of bytes:
///
/// ```
///   void main() {
///
///     List<int> secretInByteValues = [...];
///
///     SecretScheme ss = new SecretScheme(numberOfPartsToGenerate, thresholdForJoining);
///
///     Map<int, List<int>> shares = ss.createShares(secretInByteValues);
///
///     ...
///
/// ```
///
/// To combine shares to regenerate a secret:
///
/// ```
///
///     List<int> recombinedSecretInBytes = ss.combineShares(shares);
///
///   }
///
/// ```
library dart_ssss;

export 'src/secret_scheme.dart';
