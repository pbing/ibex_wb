#include <cstddef>

#include "sequence.hpp"

void sequence::add(std::shared_ptr<transaction> seqitem) {
  seq.push_back(seqitem);
}

void sequence::print() {
  for (auto it = seq.begin(); it != seq.end(); ++it) {
    (*it)->print();
  }
}
