package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func parseInputFile(fullPath string) ([]string, []int) {
	dat, err := os.ReadFile(fullPath)
	check(err)
	var tags []string
	var ints []int
	lines := strings.Split(string(dat), "\n")

	for _, line := range lines {
		if line == "" {
			continue
		}
		parts := strings.Split(line, " ")
		tag := parts[0]
		int, err := strconv.Atoi(parts[1])

		check(err)
		tags = append(tags, tag)
		ints = append(ints, int)
	}
	return tags, ints
}

func handRank(hand string) int {
	// count the number of each distinct card
	cards := strings.Split(hand, "")
	cardCount := make(map[string]int)
	for _, card := range cards {
		cardCount[card]++
	}

	if len(cardCount) == 1 {
		// five of a kind
		return 7
	}

	if len(cardCount) == 5 {
		// high card
		return 1
	}
	if len(cardCount) == 4 {
		// one pair
		return 2
	}
	if len(cardCount) == 3 {
		// two pair or three of a kind
		for _, count := range cardCount {
			if count == 3 {
				// three of a kind
				return 4
			}
		}
		// two pair
		return 3
	}
	if len(cardCount) == 2 {
		// full house or four of a kind
		for _, count := range cardCount {
			if count == 4 {
				// four of a kind
				return 6
			}
		}
		// full house
		return 5
	}
	return 0
}

func cardRank(card string) int {
	rank := card[0]
	switch rank {
	case 'A':
		return 14
	case 'K':
		return 13
	case 'Q':
		return 12
	case 'J':
		return 11
	case 'T':
		return 10
	default:
		return int(rank - '0')
	}
}

func isStrictlyHigherThanCard(card1 string, card2 string) bool {
	rank1 := cardRank(card1)
	rank2 := cardRank(card2)
	if rank1 > rank2 {
		return true
	}
	if rank1 < rank2 {
		return false
	}
	return false
}

func isStrictlyHigherThanHandInTie(hand1 string, hand2 string) bool {
	cards1 := strings.Split(hand1, "")
	cards2 := strings.Split(hand2, "")
	for i := 0; i < len(cards1); i++ {
		if isStrictlyHigherThanCard(cards1[i], cards2[i]) {
			return true
		}
		if isStrictlyHigherThanCard(cards2[i], cards1[i]) {
			return false
		}
	}
	return false
}

func isStrictlyHigherThanHand(hand1 string, hand2 string) bool {
	rank1 := handRank(hand1)
	rank2 := handRank(hand2)
	if rank1 > rank2 {
		return true
	}
	if rank1 < rank2 {
		return false
	}
	return isStrictlyHigherThanHandInTie(hand1, hand2)
}

func main() {
	hands, bets := parseInputFile("../inputs/input.txt")

	for i := 0; i < len(hands); i++ {
		for j := i + 1; j < len(hands); j++ {
			if isStrictlyHigherThanHand(hands[i], hands[j]) {
				hands[i], hands[j] = hands[j], hands[i]
				bets[i], bets[j] = bets[j], bets[i]
			}
		}
	}

	sum := 0
	for i := 0; i < len(hands); i++ {
		sum += (i + 1) * bets[i]
	}

	fmt.Printf("%d\n", sum)
}
