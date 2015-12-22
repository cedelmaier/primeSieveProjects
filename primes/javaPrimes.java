//javaPrimes.java

import java.util.Arrays;

public class javaPrimes {
    private static class primeResults {
        int pc;
        int maxprime;
    }
    //Find primes using java!
    public static void main(String []args) {
        //Find the limit
        int limit = 1;
        primeResults results = new primeResults();
        if(args.length > 0) {
            try {
                limit = Integer.parseInt(args[0]);
            } catch (NumberFormatException e) {
                System.err.println("Argument" + args[0] + " must be an integer.");
                System.exit(1);
            }
        }
        limit = 1 << limit;
        System.out.format("limit: %d%n", limit);
        
        primes235(limit, results);
        
        System.out.format("nprimes: %d, max prime: %d\n", results.pc, results.maxprime);
    }
    
    public static void primes235(int limit, primeResults results) {
        results.pc = 3;
        results.maxprime = 7;
        
        //Just hang onto these guys, its basically interpreted anyway
        int modPrimes[] = {7, 11, 13, 17, 19, 23, 29, 31};
        int gaps[] = {4, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2, 4, 6, 2, 6};
        int ndxs[] = {0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7};
        
        int lmtbf = (int)Math.floor((limit + 23 ) / 30) * 8 - 1;
        int lmtsqrt = (int)Math.sqrt(limit) - 7;
        int lmtmod = lmtsqrt % 30;
        int fIndex = 0;
        if(lmtmod < 0){
            fIndex = 30 + lmtmod;
        } else {
            fIndex = lmtmod;
        }
        lmtsqrt = (int)Math.floor(lmtsqrt/30)*8 + ndxs[fIndex];
        
        boolean []buf = new boolean[lmtbf+1];
        Arrays.fill(buf, true);
        
        //Algorithm
        for(int i = 0; i < lmtsqrt+1; i++) {
            if(buf[i]) {
                int ci = i & 7;
                int p = 30*(i>>3) + modPrimes[ci];
                int s = p * p - 7;
                int p8 = p << 3;
                for(int j = 0; j < 8; j++) {
                    int c = (int)Math.floor(s/30)*8 + ndxs[s%30];
                    for(int jj = c; jj < lmtbf+1; jj += p8) {
                        buf[jj] = false;
                    }
                    s += p * gaps[ci];
                    ci+=1;
                }
            }
        }
        
        for(int i = 0; i < lmtbf-6+(ndxs[(limit-7)%30]); i++) {
            if(buf[i]) {
                results.pc++;
                results.maxprime = 30*(i>>3) + modPrimes[i&7];
            }
        }
    }
}


