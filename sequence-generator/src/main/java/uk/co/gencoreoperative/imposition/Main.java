package uk.co.gencoreoperative.imposition;

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
    public static void main(String... args) {
        if (args.length != 1) {
            throw new IllegalArgumentException("Page total required");
        }
        int total = Integer.parseInt(args[0]);
        System.out.println(new A5Imposition().generateSequence(total));
    }
}
