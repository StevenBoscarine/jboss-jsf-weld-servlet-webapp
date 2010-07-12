#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import javax.enterprise.inject.spi.BeanManager;
import javax.inject.Inject;
import static org.junit.Assert.*;
import org.jboss.arquillian.api.Deployment;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.jboss.shrinkwrap.impl.base.asset.ByteArrayAsset;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(Arquillian.class)
public class BeanManagerTest
{
   @Deployment
   public static Archive<?> createTestArchive() {
      return ShrinkWrap.create("test.jar", JavaArchive.class)
         .addClass(HelloWorld.class)
         .addManifestResource(new ByteArrayAsset(new byte[0]), "beans.xml");
   }

   @Inject BeanManager beanManager;

   @Inject HelloWorld helloWorld;

   @Test
   public void testCdiBootstrap()
   {
      assertNotNull(beanManager);
      assertFalse(beanManager.getBeans(BeanManager.class).isEmpty());
      assertEquals("Hello, World!", helloWorld.getText());
   }
}
