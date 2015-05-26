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
		System.out.format("Limit: %d%n", limit);

		long startTime = System.nanoTime();
		eratosthenes(limit, results);
		long estimatedTime = System.nanoTime() - startTime;

		System.out.format("Eratosthenes: %dms\n", estimatedTime/1000/1000);
    	System.out.format("\tPrimes counted: %d\n", results.pc);
    	System.out.format("\tMax prime: %d\n\n\n", results.maxprime);

    	startTime = System.nanoTime();
		iprimes2(limit, results);
		estimatedTime = System.nanoTime() - startTime;

		System.out.format("Iprimes2: %dms\n", estimatedTime/1000/1000);
    	System.out.format("\tPrimes counted: %d\n", results.pc);
    	System.out.format("\tMax prime: %d\n\n\n", results.maxprime);

    	startTime = System.nanoTime();
		primes235(limit, results);
		estimatedTime = System.nanoTime() - startTime;

		System.out.format("primes235: %dms\n", estimatedTime/1000/1000);
    	System.out.format("\tPrimes counted: %d\n", results.pc);
    	System.out.format("\tMax prime: %d\n\n\n", results.maxprime);
	}

	public static void eratosthenes(int limit, primeResults results) {
		int pc = 0;
		int maxprime = 7;

		boolean []nums = new boolean[(int)limit];
		Arrays.fill(nums, true);

        nums[0] = false;
        nums[1] = false;

		for(int i = 2; i < Math.sqrt(limit); i++) {
            if(nums[i]) {
        	   for(int j = i*i; j < limit; j += i) {
        	       nums[j] = false;
        	   }
            }
    	}

    	for(int i = 0; i < limit; i++) {
    	    if(nums[i]) {
    	        pc++;
    	        maxprime = i;
    	    }
    	}

    	results.pc = pc;
    	results.maxprime = maxprime;
	}

	public static void iprimes2(int limit, primeResults results) {
		int pc = 1;
		int maxprime = 7;
		int lmtbf = (limit - 3) / 2;

		boolean []buf = new boolean[lmtbf+1];
		Arrays.fill(buf, true);

		for(int i = 0; i < (Math.sqrt(limit) - 3) / 2 + 1; i++) {
        	//printf("outeri: %ld\n", i);
        	if(buf[i]) {
        	    int p = i + i + 3;
        	    int s = p * (i + 1) + i;
        	    //printf("p: %ld, s: %ld\n", p, s);
        	    for(int j = s; j < (lmtbf + 1); j += p) {
        	        //printf("Setting %d j to off\n", j);
        	        buf[j] = false;
        	    }
        	}
    	}

    	for(int i = 0; i < lmtbf+1; i++) {
    	    if(buf[i]) {
    	        pc++;
    	        maxprime = i + i + 3;
    	    }
    	}

    	results.pc = pc;
    	results.maxprime = maxprime;
	}

	public static void primes235(int limit, primeResults results) {
		int pc = 3;
		int maxprime = 7;

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
    	        pc++;
    	        maxprime = 30*(i>>3) + modPrimes[i&7];
    	    }
    	}

		results.pc = pc;
		results.maxprime = maxprime;
	}
}



















