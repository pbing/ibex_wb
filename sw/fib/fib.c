int main(void) {
  int a, b;
  volatile int y;

  a = 0;
  b = 1;

  /* F10 = 55 (0x37) */
  for (int i = 1; i < 10; ++i) {
    y = a + b;
    a = b;
    b = y;
  }

  for (;;);
}
