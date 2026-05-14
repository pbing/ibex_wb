#pragma once

#include <deque>
#include <memory>

#include "transaction.hpp"

class sequence {
private:
  std::deque<std::shared_ptr<transaction>> seq;

public:
  void add(std::shared_ptr<transaction> seqitem);

  void print();
};

// helper macros
#define SEQADD(seq, inst) seq->add(std::shared_ptr<transaction>{new transaction{inst}})
#define SEQADD2(seq, inst, dat) seq->add(std::shared_ptr<transaction>{new transaction{inst, dat}})
