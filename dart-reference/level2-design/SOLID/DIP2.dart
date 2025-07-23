// Use this as interface
abstract class EncryptionAlgorithm { 
  String encrypt(); // <-- abstraction
}
class AlgoAES implements EncryptionAlgorithm {
  @override
  String encrypt() => "AlgoAES";
}
class AlgoRSA implements EncryptionAlgorithm {
  @override
  String encrypt() => "AlgoRSA";
}

class FileManager {
   void secureFile(EncryptionAlgorithm algo) {
       print(algo.encrypt());
   }
}

main() 
{
  var filemanager = FileManager();
  // Object is injected (dependency injection) to implement the DIP
  filemanager.secureFile(AlgoAES());
  filemanager.secureFile(AlgoRSA());
}