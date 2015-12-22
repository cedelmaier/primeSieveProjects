package main

import (
	"flag"
	"fmt"
	"math"
	"runtime"
	"strconv"
)

var power = flag.String("n", "", "power of 2 for limit")

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	limit := uint64(4)
	flag.Parse()
	if *power != "" {
		limit, _ = strconv.ParseUint(*power, 10, 64)
	}
	limit = 1 << limit
	fmt.Printf("limit: %v\n", limit)
	pc, maxprime := uint64(4), uint64(7)

	pc, maxprime = primes235(limit)
	fmt.Printf("nprimes: %v, max prime: %v\n", pc, maxprime)
}

func primes235(limit uint64) (uint64, uint64) {
	modPrms := []float64{7, 11, 13, 17, 19, 23, 29, 31}
	gaps := []float64{4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6}
	ndxs := []float64{0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7}

	lmtbf := math.Floor((float64(limit)+23)/30)*8 - 1
	lmtsqrt := math.Floor(math.Sqrt(float64(limit))) - 7
	lmtsqrt = math.Floor(lmtsqrt/30)*8 + ndxs[int64(lmtsqrt)%30]
	buf := make([]bool, int64(lmtbf)+1)
	for i := int64(0); i < int64(lmtbf)+1; i++ {
		buf[i] = true
	}
	//Now the actual algorithm (yikes)
	for i := int64(0); i < int64(lmtsqrt)+1; i++ {
		if buf[i] {
			ci := i & 7
			p := 30*(i>>3) + int64(modPrms[ci])
			s := p*p - 7
			p8 := p << 3
			for j := 0; j < 8; j++ {
				c := math.Floor(float64(s/30))*8 + ndxs[s%30]
				for j := int64(c); j < int64(len(buf)); j += p8 {
					buf[j] = false
				}
				s += p * int64(gaps[ci])
				ci += 1
			}
		} //buf loop
	} //i loop

	pc := int64(3)
	maxprime := int64(7)

	for i := int64(0); i < int64(lmtbf-6+(ndxs[(limit-7)%30])); i++ {
		if buf[i] {
			pc++
			maxprime = 30*(i>>3) + int64(modPrms[i&7])
		}
	}

	return uint64(pc), uint64(maxprime)
}
