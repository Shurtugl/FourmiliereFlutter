import 'allele.dart';

class Dna {
  List<Allele> alleles = [];

  Dna(int nbOfAllele) {
    for (int i = 0; i < nbOfAllele; i++) {
      alleles.add(Allele());
    }
  }
  getHash(){
    return alleles.hashCode;
  }

  Dna reproduce(int mutationChance){
    Dna copyCat = Dna(alleles.length);
    copyCat.alleles = [];
    for (Allele allele in alleles){
      Allele? newAllele;
      if (mutationChance > 100){
        newAllele = allele.reproduce(100);
        mutationChance -= 100;
      }else{
        newAllele = allele.reproduce(mutationChance);
      }
      copyCat.alleles.add(newAllele!);
    }
    return copyCat;
  }

  @override
  String toString() {
    String stringBuilder = "";
    for (Allele a in alleles){
      stringBuilder += a.toString();
    }
    return stringBuilder;
  }
}