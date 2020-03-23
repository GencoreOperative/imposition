package uk.co.gencoreoperative.imposition;

import org.assertj.core.api.Assertions;
import org.junit.Test;

public class MainTest {

    private Main main = new Main();

    @Test
    public void shouldMatchExpectedOutput() {
        String result = main.process(16);
        Assertions.assertThat(result).isEqualTo("16r,1r,15l,2l,14r,3r,13l,4l,12r,5r,11l,6l,10r,7r,9l,8l");
    }
}