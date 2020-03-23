package uk.co.gencoreoperative.imposition;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * This utility needs perform the following steps:
 * <ul>
 *     <li>Read the requested input parameter</li>
 *     <li>Convert it to an even number if it is not</li>
 *     <li>Generate the comma separated number sequence</li>
 * </ul>
 * <p>
 *     Example: For 16 pages, we have the following imposition sequence:
 *     <pre>16r,1r,15l,2l,14r,3r,13l,4l,12r,5r,11l,6l,10r,7r,9l,8l</pre>
 * </p>
 */
public class Main {
    public String process(int total) {
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

    public static void main(String... args) {
        if (args.length != 1) {
            throw new IllegalArgumentException("Page total required");
        }
        int total = Integer.parseInt(args[0]);
        System.out.println(new Main().process(total));
    }
}
