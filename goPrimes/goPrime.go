package main

import (
	"flag"
	"fmt"
	"log"
	"math"
	"os"
	"runtime/pprof"
	"strconv"
	"time"
)

var cpuprofile = flag.String("cpuprofile", "", "write cpu profile to file")
var power = flag.String("n", "", "power of 2 for limit")

func main() {
	limit := uint64(4)
	flag.Parse()
	if *cpuprofile != "" {
		f, err := os.Create(*cpuprofile)
		if err != nil {
			log.Fatal(err)
		}
		pprof.StartCPUProfile(f)
		defer pprof.StopCPUProfile()
	}
	if *power != "" {
		limit, _ = strconv.ParseUint(*power, 10, 64)
	}
	limit = 1 << limit
	fmt.Printf("Limit: %v\n", limit)
	pc, maxprime := uint64(4), uint64(7)

	pc, maxprime = eratosthenes(limit)
	fmt.Printf("\tPrimes counted: %v\n", pc)
	fmt.Printf("\tMax prime: %v\n\n\n", maxprime)

	pc, maxprime = eratosthenes32(limit)
	fmt.Printf("\tPrimes counted: %v\n", pc)
	fmt.Printf("\tMax prime: %v\n\n\n", maxprime)

	pc, maxprime = iprimes2(limit)
	fmt.Printf("\tPrimes counted: %v\n", pc)
	fmt.Printf("\tMax prime: %v\n\n\n", maxprime)

	pc, maxprime = primes235(limit)
	fmt.Printf("\tPrimes counted: %v\n", pc)
	fmt.Printf("\tMax prime: %v\n\n\n", maxprime)
}

func eratosthenes(limit uint64) (uint64, uint64) {
	defer timeTrack(time.Now(), "Eratosthenes")

	nums := make([]bool, limit) //creates a false array
	for i := range nums {
		nums[i] = true
	}
	nums[0] = true
	nums[1] = true

	for i := uint64(2); i < uint64(math.Sqrt(float64(limit))); i++ {
		//fmt.Printf("\ti = %v\n", i)
		for j := uint64(i * i); j < limit; j += i {
			//fmt.Printf("\t\tj = %v\n", j)
			if nums[i] {
				nums[j] = false
			}
		}
	}

	pc, maxprime := uint64(0), uint64(0)

	for n, num := range nums {
		if num {
			pc++
			maxprime = uint64(n)
		}
	}

	//remove the first two from pc
	pc -= 2

	return pc, maxprime
}

func eratosthenes32(limit_64 uint64) (uint64, uint64) {
	defer timeTrack(time.Now(), "Eratosthenes32")

	limit := uint32(limit_64)
	nums := make([]bool, limit) //creates a false array
	for i := range nums {
		nums[i] = true
	}
	nums[0] = true
	nums[1] = true

	for i := uint32(2); i < uint32(math.Sqrt(float64(limit))); i++ {
		//fmt.Printf("\ti = %v\n", i)
		for j := uint32(i * i); j < limit; j += i {
			//fmt.Printf("\t\tj = %v\n", j)
			if nums[i] {
				nums[j] = false
			}
		}
	}

	pc, maxprime := uint32(0), uint32(0)

	for n, num := range nums {
		if num {
			pc++
			maxprime = uint32(n)
		}
	}

	//remove the first two from pc
	pc -= 2

	return uint64(pc), uint64(maxprime)
}

func iprimes2(limit uint64) (uint64, uint64) {
	defer timeTrack(time.Now(), "Iprimes2")
	lmtbf := uint64(math.Floor(float64((limit - 3) / 2)))
	//fmt.Printf("lmtbf: %v\n", lmtbf)

	buf := make([]bool, lmtbf+1)
	for i := range buf {
		buf[i] = true
	}

	pc := uint64(1)
	maxprime := uint64(1)

	for i := uint64(0); i < uint64(math.Floor((math.Sqrt(float64(limit))-3)/2)+1); i++ {
		//fmt.Printf("outeri: %v\n", i)
		if buf[i] {
			p := i + i + 3
			s := p*(i+1) + i
			//fmt.Printf("p: %v, s: %v\n", p, s)
			//Get every other item, starting at s stepping by p
			for j := s; j < uint64(len(buf)); j += p {
				//fmt.Printf("Setting %v to 0\n", j)
				buf[j] = false
			}
			//fmt.Printf("buf: %v\n", buf)
		}
	}

	for i := uint64(0); i < (lmtbf + 1); i++ {
		if buf[i] {
			//fmt.Printf("buf[%v] = %v\n", i, i+i+3)
			pc++
			maxprime = i + i + 3
		}
	}
	return pc, maxprime
}

func primes235(limit uint64) (uint64, uint64) {
	defer timeTrack(time.Now(), "primes235")

	modPrms := []float64{7, 11, 13, 17, 19, 23, 29, 31}
	gaps := []float64{4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6}
	ndxs := []float64{0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7}

	//Have to explicitly do everything as floats, or the rounding breaks everything
	lmtbf := math.Floor((float64(limit)+23)/30)*8 - 1
	lmtsqrt := math.Floor(math.Sqrt(float64(limit))) - 7
	lmtmod := int64(lmtsqrt) % 30
	var fIndex int64
	if lmtmod < 0 {
		fIndex = 30 + lmtmod
	} else {
		fIndex = lmtmod
	}
	lmtsqrt = math.Floor(lmtsqrt/30)*8 + ndxs[fIndex]
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

	pc := int64(4 - 1)
	maxprime := int64(7)

	for i := int64(0); i < int64(lmtbf-6+(ndxs[(limit-7)%30])); i++ {
		if buf[i] {
			pc++
			maxprime = 30*(i>>3) + int64(modPrms[i&7])
		}
	}

	return uint64(pc), uint64(maxprime)
}

func timeTrack(start time.Time, name string) {
	elapsed := time.Since(start)
	log.Printf("%s took %s", name, elapsed)
}
