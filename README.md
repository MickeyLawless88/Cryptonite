# CRYPTONITE v2.0 - File Encryption Utility

**Author:** Mickey L.  
**Date:** June 27, 2021  
**Platform:** DOS / BASIC

---

## Cipher Type

Position-Based Caesar Variant with Password-Derived Key and ASCII Folding

---

## Cipher Description

Each character is encoded by adding the character's position in the line and the total ASCII sum of a user-supplied password. The result is wrapped back into the printable range. Non-printable characters (below 32 or above 126) are passed through unchanged.

---

## Key Derivation

The password is converted into a key (called `PWD`) by summing the ASCII values of all characters in the password.

**Example:**

```
Password = DOG
D = 68, O = 79, G = 71
PWD = 68 + 79 + 71 = 218
```

In the provided example, `PWD = 29`.

---

## Pseudocode

### Encoding

```plaintext
For each line in the input file:
  For each character at position T (starting from 1):
    If ASCII(char) < 32 or > 126:
      Output char unchanged
    Else:
      CDD = ASCII(char) + PWD + T
      While CDD > 220:
        CDD = CDD - 188
      While CDD > 126:
        CDD = CDD - 94
      Output CHR(CDD)
```

### Decoding

```plaintext
For each line in the input file:
  For each character at position T (starting from 1):
    If ASCII(char) < 32 or > 126:
      Output char unchanged
    Else:
      UCDD = ASCII(char) - PWD - T
      If UCDD < -250:
        UCDD = UCDD + 282
      If UCDD < -156:
        UCDD = UCDD + 188
      While UCDD < 32:
        UCDD = UCDD + 94
      Output CHR(UCDD)
```

---

## BASIC Code Example

### Encoding

```basic
FOR T = 1 TO LEN(Line$)
  Char$ = MID$(Line$, T, 1)
  Code = ASC(Char$)

  IF Code < 32 OR Code > 126 THEN
    Encoded$ = Encoded$ + Char$  ' leave unchanged
  ELSE
    Code = Code + PWD + T
    WHILE Code > 220
      Code = Code - 188
    WEND
    WHILE Code > 126
      Code = Code - 94
    WEND
    Encoded$ = Encoded$ + CHR$(Code)
  END IF
NEXT T
PRINT #1, Encoded$
```

### Decoding

```basic
FOR T = 1 TO LEN(Line$)
  Char$ = MID$(Line$, T, 1)
  Code = ASC(Char$)

  IF Code < 32 OR Code > 126 THEN
    Decoded$ = Decoded$ + Char$  ' leave unchanged
  ELSE
    Code = Code - PWD - T
    IF Code < -250 THEN
      Code = Code + 282
    END IF
    IF Code < -156 THEN
      Code = Code + 188
    END IF
    WHILE Code < 32
      Code = Code + 94
    WEND
    Decoded$ = Decoded$ + CHR$(Code)
  END IF
NEXT T
PRINT #1, Decoded$
```

---

## Usage Instructions

To encode a file:

```bash
CDR ENCODE filename.txt password
```

To decode a file:

```bash
CDR DECODE filename.txt password
```

After encoding or decoding, the original file is deleted and the output file is renamed to match the original name.

---

## Important Notes

- This cipher is **not secure** and should not be used for protecting sensitive data.
- It is useful for light obfuscation or educational purposes.
- Only characters in the printable ASCII range (32–126) are encoded; all others are passed unchanged.
- The process is fully reversible using the correct password.
