# 1. Definicja kompilatora i rygorystycznych flag inżynieryjnych
CXX := clang++
CXXFLAGS := -std=c++20 -g -ggdb -fcolor-diagnostics -fansi-escape-codes \
            -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion \
            -Wsign-conversion -Werror
INCLUDES := -Iinclude

# Flagi generowania zależności
DEPFLAGS := -MMD -MP

# 2. Mapowanie struktury katalogów
SRC_DIR := src
BUILD_DIR := build

# 3. Dynamiczne wyszukiwanie plików
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)
TARGET := $(BUILD_DIR)/app

# 4. Reguły budowania
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(INCLUDES) -c $< -o $@

# 5. Czyszczenie artefaktów
clean:
	rm -rf $(BUILD_DIR)/*

.PHONY: all clean

# 6. Dołączenie wygenerowanych plików zależności
-include $(DEPS)
