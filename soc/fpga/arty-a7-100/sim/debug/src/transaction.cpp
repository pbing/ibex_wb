#include <cstdio>

#include "transaction.hpp"

void transaction::print() {
  printf("mode=%d req=0x%011llx len=%lu\n", mode, req, len);
}
