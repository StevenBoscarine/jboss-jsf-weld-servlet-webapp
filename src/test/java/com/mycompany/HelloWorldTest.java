package com.mycompany;

import static org.junit.Assert.*;
import org.junit.Test;

public class HelloWorldTest
{
   @Test
   public void testGetText() {
      HelloWorld fixture = new HelloWorld();
      assertEquals("Hello, World!", fixture.getText());
   }
}
