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
		long limit = 1;
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
	}

	public static void eratosthenes(long limit, primeResults results) {
		int pc = 4;
		int maxprime = 7;

		boolean []nums = new boolean[(int)limit];
		Arrays.fill(nums, true);

		for(int i = 2; i < Math.sqrt(limit); i++) {
        	for(int j = i*i; j < limit; j += i) {
        	    if(nums[i]) {
        	        nums[j] = false;
        	    }
        	}
    	}

    	pc -= 6;

    	for(int i = 0; i < limit; i++) {
    	    if(nums[i]) {
    	        pc++;
    	        maxprime = i;
    	    }
    	}

    	results.pc = pc;
    	results.maxprime = maxprime;
	}
}