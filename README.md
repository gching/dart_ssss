# dart_ssss

A Dart library that implements [Shamir's Secret Sharing Scheme](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing) 
over [GF(256)](http://www.cs.utsa.edu/~wagner/laws/FFM.html).

Given a secret in bytes, this package can assist in splitting up the secret into `n` parts and would be able to 
reconstruct the secret in bytes given a `t` threshold.

I would highly recommend you look at the the wikipedia page above to learn about the workings of Shamir's Secret Sharing
Scheme.

## Getting Started


## Usage 

To generate shares / parts for a secret of bytes:

```
     void main() {
        
        List<int> secretInByteValues = [...];
        
        SecretScheme ss = new SecretScheme(numberOfPartsToGenerate, thresholdForJoining);
        
        Map<int, List<int>> shares = ss.createShares(secretInByteValues);
        
        ...
          
     
```

To combine shares to regernate a secret:

```
        List<int> recombinedSecretInBytes = ss.combineShares(shares);
    }
```

## Limitations / Caveats

Given that the package is implemented over GF(256), it means that the max number of shares / parts it can generate is
255. With that said, it is not advisable to generate 255 shares / parts as an adversary can 
[forge a secret](https://crypto.stackexchange.com/questions/54578/how-to-forge-a-shamir-secret-share).    

Shamir's Secret Sharing Scheme does not guarantee integrity, so if you are looking for something where you can verify
shares or the resulting secret, this package is not for you.

## License

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
