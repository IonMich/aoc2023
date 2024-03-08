#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <limits>

unsigned stou(std::string const & str, size_t * idx = 0, int base = 10) {
    // https://stackoverflow.com/a/8715855/10119867
    // string to unsigned
    unsigned long result = std::stoul(str, idx, base);
    if (result > std::numeric_limits<unsigned>::max()) {
        throw std::out_of_range("stou");
    }
    return result;
}

auto extract_seed_ranges_from_line(std::string line) {
    std::vector<unsigned> startSeeds;
    std::vector<unsigned> lengths;
    while (line.find(" ") != std::string::npos) {
        std::string seed_str = line.substr(0, line.find(" "));
        line.erase(0, line.find(" ") + 1);
        startSeeds.push_back(stou(seed_str));
        std::string length_str = line.substr(0, line.find(" "));
        line.erase(0, line.find(" ") + 1);
        lengths.push_back(stou(length_str));
    }
    return std::make_pair(startSeeds, lengths);
}

auto sort_seed_pairs(std::pair<std::vector<unsigned>, std::vector<unsigned>> seed_pairs) {
    // sort the seed_pairs by the start seeds
    for (int i = 0; i < seed_pairs.first.size(); i++) {
        for (int j = i+1; j < seed_pairs.first.size(); j++) {
            if (seed_pairs.first[i] > seed_pairs.first[j]) {
                std::swap(seed_pairs.first[i], seed_pairs.first[j]);
                std::swap(seed_pairs.second[i], seed_pairs.second[j]);
            }
        }
    }
    return seed_pairs;
}

auto process_seed_for_source_range(
    unsigned seed_start,
    unsigned seed_length,
    unsigned source,
    unsigned length,
    unsigned destination) {
    // params: seed_start, seed_length, source, length, destination
    // returns: (std::pair<unsigned, unsigned> remaining_before, std::pair<unsigned, unsigned> remaining_after, std::pair<unsigned, unsigned> mapped_pair)
    // process the (seed, seed_length) pairs:
    // - find the overlap (a,b) between (seed, seed+seed_length) and (source, source+length)
    // - if the overlap is empty, skip the pair
    // - keep the non-overlapping parts of the seed (if any), i.e. replace (seed, seed_length) with (seed, a-seed) and (b, seed+seed_length-b)
    // - add (a + destination - source, b-a) to the next pairs

    std::pair<unsigned, unsigned> remaining_before_source_start;
    std::pair<unsigned, unsigned> remaining_after_source_end;
    std::pair<unsigned, unsigned> mapped_pair;
    unsigned seed_end = seed_start + seed_length;
    unsigned source_end = source + length;
    unsigned a = std::max(seed_start, source);
    unsigned b = std::min(seed_end, source_end);
    if (seed_start > source_end) {
        remaining_after_source_end = std::make_pair(seed_start, seed_length);
    } else if (seed_end < source) {
        remaining_before_source_start = std::make_pair(seed_start, seed_length);
    } else {
        if (seed_start < source) {
            remaining_before_source_start = std::make_pair(seed_start, a-seed_start);
        }
        if (seed_end > source_end) {
            remaining_after_source_end = std::make_pair(b, seed_end-b);
        }
        mapped_pair = std::make_pair(a + destination - source, b - a);
    }
    return std::make_tuple(remaining_before_source_start, remaining_after_source_end, mapped_pair);
}

int main() {
    std::ifstream input("inputs/input.txt");
    std::string line;
    std::getline(input, line);
    line.erase(0, line.find(":") + 2);
    
    auto seed_pairs = extract_seed_ranges_from_line(line);
    auto seedPairsVector = seed_pairs;
    seedPairsVector = sort_seed_pairs(seedPairsVector);
    auto seedPairsVectorNext = std::make_pair(std::vector<unsigned>(), std::vector<unsigned>());
    std::getline(input, line);
    while (std::getline(input, line)) {
        if (line.empty()) {
            for (auto seed : seedPairsVectorNext.first) {
                seedPairsVector.first.push_back(seed);
            }
            for (auto seed : seedPairsVectorNext.second) {
                seedPairsVector.second.push_back(seed);
            }
            seedPairsVectorNext = std::make_pair(std::vector<unsigned>(), std::vector<unsigned>());
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


        auto replacementPairs = std::make_pair(std::vector<unsigned>(), std::vector<unsigned>());
        for (int i = 0; i < seedPairsVector.first.size(); i++) {
            auto [remaining_before, remaining_after, mapped_pair] = process_seed_for_source_range(
                seedPairsVector.first[i],
                seedPairsVector.second[i],
                source,
                length,
                destination
            );
            if (remaining_before.second > 0) {
                replacementPairs.first.push_back(remaining_before.first);
                replacementPairs.second.push_back(remaining_before.second);
            }
            if (remaining_after.second > 0) {
                replacementPairs.first.push_back(remaining_after.first);
                replacementPairs.second.push_back(remaining_after.second);
            }
            if (mapped_pair.second > 0) {
                seedPairsVectorNext.first.push_back(mapped_pair.first);
                seedPairsVectorNext.second.push_back(mapped_pair.second);
            }
        }
        seedPairsVector = replacementPairs;
    }
    unsigned min_seed_start = std::numeric_limits<unsigned>::max();
    for (int i = 0; i < seedPairsVector.first.size(); i++) {
        if (seedPairsVector.first[i] < min_seed_start) {
            min_seed_start = seedPairsVector.first[i];
        }
    }
    for (int i = 0; i < seedPairsVectorNext.first.size(); i++) {
        if (seedPairsVectorNext.first[i] < min_seed_start) {
            min_seed_start = seedPairsVectorNext.first[i];
        }
    }
    std::cout << min_seed_start << std::endl;

    return 0;
}
