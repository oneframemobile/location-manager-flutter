# Barcode Manager - Flutter

### Introduction

### Getting Started

### Content

### Scan a Barcode

### Create a QR Code

## Introduction

Koçsistem supports Barcode Operations component that works with of Qr Barcode providers.

## Getting Started

Following lines need to be added in related files. Make sure to sync project after modification:

```
yaml.dart
```
```
qr_code_manager_flutter:
git:
url: https://github.com/oneframemobile/barcode-manager-flutter
```
## Content

## BarcodeManager

QR Code Manager has two functions.

## scanBarcode

## createQrCode

## Scan a QR Code

```
createQrCode
```
```
Container(
child: BarcodeManager.createQrCode(data: "QR Code Created"))
```

## Create a QR Code

```
createQrCode
```
```
FlatButton(
color: Colors.red,
child: Padding(
padding: EdgeInsets.all(50),
child: Text("Scan a Barcode",
style: TextStyle(color: Colors.white),),),
onPressed: () async {
var scannedValue = await BarcodeManager.scanBarcode();
print(scannedValue);
}),
```

