#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <limits>

unsigned stou(std::string const & str, size_t * idx = 0, int base = 10) {
    // https://stackoverflow.com/a/8715855/10119867
    unsigned long result = std::stoul(str, idx, base);
    if (result > std::numeric_limits<unsigned>::max()) {
        throw std::out_of_range("stou");
    }
    return result;
}

auto extract_seeds_from_line(std::string line) {
    std::vector<unsigned> seedVector;
    while (line.find(" ") != std::string::npos) {
        std::string seed_str = line.substr(0, line.find(" "));
        line.erase(0, line.find(" ") + 1);
        seedVector.push_back(stou(seed_str));
    }
    seedVector.push_back(stou(line));
    return seedVector;
}

int main() {
    std::ifstream input("inputs/input.txt");
    std::string line;
    std::getline(input, line);
    line.erase(0, line.find(":") + 2);
    
    auto seedVector = extract_seeds_from_line(line);
    auto seedVectorNext = std::vector<unsigned>();
    std::sort(seedVector.begin(), seedVector.end());
    std::getline(input, line);
    while (std::getline(input, line)) {
        if (line.empty()) {
            for (auto seed : seedVectorNext) {
                seedVector.push_back(seed);
            }
            seedVectorNext = std::vector<unsigned>();
            continue;
        }
        if (line.find("-to-") != std::string::npos) {
            continue;
        }
        
        std::uint32_t destination = stou(line.substr(0, line.find(" ")));
        line.erase(0, line.find(" ") + 1);
        std::uint32_t source = stou(line.substr(0, line.find(" ")));
        line.erase(0, line.find(" ") + 1);
        std::uint32_t length = stou(line.substr(0, line.find(" ")));
        line.erase(0, line.find(" ") + 1);

        std::vector<unsigned> seedsToDelete;
        for (auto seed : seedVector) {
            if (seed >= source && seed <= source + length-1) {
                seedsToDelete.push_back(seed);
                seedVectorNext.push_back(seed + destination - source);
            }
        }
        for (auto item : seedsToDelete) {
            seedVector.erase(
                std::remove(seedVector.begin(), seedVector.end(), item), 
                seedVector.end());
        }
    }
    for (auto seed : seedVectorNext) {
        seedVector.push_back(seed);
    }
    std::cout << *std::min_element(seedVector.begin(), seedVector.end()) << std::endl;
    return 0;
}
