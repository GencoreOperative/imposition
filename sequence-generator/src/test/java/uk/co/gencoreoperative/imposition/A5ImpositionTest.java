package uk.co.gencoreoperative.imposition;

import org.assertj.core.api.Assertions;
import org.junit.Test;

public class A5ImpositionTest {
    private final A5Imposition main = new A5Imposition();

    @Test
    public void shouldMatchExpectedOutput() {
        String result = main.generateSequence(16);
        Assertions.assertThat(result).isEqualTo("16r,1r,15l,2l,14r,3r,13l,4l,12r,5r,11l,6l,10r,7r,9l,8l");
    }
}