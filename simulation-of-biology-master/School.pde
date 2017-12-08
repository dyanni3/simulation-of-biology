
// A structure to contain all of the Fish!

class School {
  ArrayList<Fish> fishes; 

  School() {
    fishes = new ArrayList<Fish>(); 
  }

  void run() {
    for (Fish fish : fishes) {
      fish.update(fishes);
      fish.show();
    }
  }

  void addFish(Fish fish) {
    fishes.add(fish);
  }

}