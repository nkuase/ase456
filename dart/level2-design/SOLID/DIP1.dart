class AlgoRSA { 
  String encrypt() => "AlgoRSA";
}
class AlgoAES { 
  String encrypt() => "AlgoAES";
}
class FileManager {
   void secureRSAFile(AlgoRSA algo) {
     print(algo.encrypt());
   }
   void secureAESFile(AlgoAES algo) {
     print(algo.encrypt());
   }   
}

main() 
{
  var filemanager = FileManager();
  filemanager.secureAESFile(AlgoAES());
  filemanager.secureRSAFile(AlgoRSA());
}