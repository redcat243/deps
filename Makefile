CXX = g++
CXXFLAGS = -Wall -Wextra -O2 -std=c++11 `pkg-config --cflags gtk+-3.0 webkit2gtk-4.1`
LDFLAGS = `pkg-config --libs gtk+-3.0 webkit2gtk-4.1`

all: catbrowser

catbrowser: main.cpp
	$(CXX) $(CXXFLAGS) -o catbrowser main.cpp $(LDFLAGS)

clean:
	rm -f catbrowser
