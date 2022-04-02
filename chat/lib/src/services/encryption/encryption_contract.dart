//@dart =2.9

abstract class IEncryption {
  String encrypt(String text);
  String decrypt(String encryptedText);
}
