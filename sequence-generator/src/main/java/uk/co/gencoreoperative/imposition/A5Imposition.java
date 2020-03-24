package uk.co.gencoreoperative.imposition;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * This version of the imposition algorithm will layout pages in a print order that
 * imposes two pages per side with a double sided print job.
 * <p>
 *     Example: For 16 pages, we have the following imposition sequence:
 *     <pre>16r,1r,15l,2l,14r,3r,13l,4l,12r,5r,11l,6l,10r,7r,9l,8l</pre>
 * </p>
 */
public class A5Imposition implements Imposition {
    @Override
    public String generateSequence(int total) {
        // Make even
        if (total % 2 != 0) {
            total = total +1;
        }

        String result = "";
        List<String> numbers = IntStream.range(1, total + 1).mapToObj(String::valueOf).collect(Collectors.toList());
        boolean leftRight = false;
        while (!numbers.isEmpty()) {
            String number = numbers.remove(numbers.size() - 1);
            result += number + (leftRight ? "l" : "r");
            result += ",";

            number = numbers.remove(0);
            result += number + (leftRight ? "l" : "r");
            result += ",";

            leftRight = !leftRight;
        }

        // Trim the trailing comma
        if (result.length() != 0) {
            result = result.substring(0, result.length() - ",".length());
        }

        return result;
    }
}
