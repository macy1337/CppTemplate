# 1. Detekcja systemu operacyjnego
OS := $(shell uname -s)

# 2. Definicja wspólnych flag inżynieryjnych
CXXFLAGS := -std=c++20 -g -ggdb -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror
INCLUDES := -Iinclude
DEPFLAGS := -MMD -MP

# 3. Konfiguracja zależna od platformy (macOS vs Linux)
ifeq ($(OS), Darwin)
    # Środowisko Apple (domyślnie Clang)
    CXX := clang++
    CXXFLAGS += -fcolor-diagnostics -fansi-escape-codes
else ifeq ($(OS), Linux)
    # Środowisko Linux (domyślnie GCC, choć Clang jest w pełni wspierany)
    CXX := g++
    CXXFLAGS += -fdiagnostics-color=always
else
    $(error Niewspierany system operacyjny: $(OS))
endif

# 4. Mapowanie struktury katalogów
SRC_DIR := src
BUILD_DIR := build

# 5. Dynamiczne wyszukiwanie plików
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)
TARGET := $(BUILD_DIR)/app

# 6. Reguły budowania
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(INCLUDES) -c $< -o $@

# 7. Czyszczenie artefaktów
clean:
	rm -rf $(BUILD_DIR)/*

.PHONY: all clean

# 8. Dołączenie wygenerowanych plików zależności
-include $(DEPS)
