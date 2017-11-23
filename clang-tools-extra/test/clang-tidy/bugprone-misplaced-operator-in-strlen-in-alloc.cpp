// RUN: %check_clang_tidy %s bugprone-misplaced-operator-in-strlen-in-alloc %t

namespace std {
typedef __typeof(sizeof(int)) size_t;
void *malloc(size_t);

size_t strlen(const char *);
} // namespace std

namespace non_std {
typedef __typeof(sizeof(int)) size_t;
void *malloc(size_t);

size_t strlen(const char *);
} // namespace non_std

void bad_std_malloc_std_strlen(char *name) {
  char *new_name = (char *)std::malloc(std::strlen(name + 1));
  // CHECK-MESSAGES: :[[@LINE-1]]:28: warning: addition operator is applied to the argument of strlen
  // CHECK-FIXES: {{^  char \*new_name = \(char \*\)std::malloc\(}}std::strlen(name) + 1{{\);$}}
}

void ignore_non_std_malloc_std_strlen(char *name) {
  char *new_name = (char *)non_std::malloc(std::strlen(name + 1));
  // CHECK-MESSAGES-NOT: :[[@LINE-1]]:28: warning: addition operator is applied to the argument of strlen
  // Ignore functions of the malloc family in custom namespaces
}

void ignore_std_malloc_non_std_strlen(char *name) {
  char *new_name = (char *)std::malloc(non_std::strlen(name + 1));
  // CHECK-MESSAGES-NOT: :[[@LINE-1]]:28: warning: addition operator is applied to the argument of strlen
  // Ignore functions of the strlen family in custom namespaces
}
