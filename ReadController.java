import net.java.games.input.*;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

class ReadController{
  static void read(GamePadWrapper gp,ArcadeUI aui){
    /* Get the available controllers */
      Controller[] controllers = ControllerEnvironment
          .getDefaultEnvironment().getControllers();
      boolean hasValidController =false;
      for (int i = 0; i < controllers.length; i++) {
        if(controllers[i].getType().equals(Controller.Type.GAMEPAD)||controllers[i].getType().equals(Controller.Type.STICK)) {
          hasValidController = true;
          break;
        }
      }
      if (!hasValidController) {
        System.out.println("Found no valid controllers.");
        String conectedControllers ="";
        for (int i = 0; i < controllers.length; i++) {
          conectedControllers += "device: "+controllers[i]+" | type: "+controllers[i].getType()+"\n";
        }
        aui.controllerError = true;
        aui.controlerErrorTimeStamp = aui.millis();
        JFrame jf=new JFrame();
        jf.setAlwaysOnTop(true);
        JOptionPane.showMessageDialog(jf,"We were not able to find any controller devices connected to this system.\nA GamePad controller/joystick controller is required to play this version of the game.\nList of found controll devices ======\n"+conectedControllers+"======\nThe program will now close","No Controllers Found!", JOptionPane.ERROR_MESSAGE);
        System.exit(420);
      }

      for (int i = 0; i < controllers.length; i++) {
        //only check inputs from gamepads or fligh sticks (on linux, the arcade controlls show up as a flight stick)
        if(!controllers[i].getType().equals(Controller.Type.GAMEPAD) && !controllers[i].getType().equals(Controller.Type.STICK)) {
          continue;
        }
        /* Remember to poll each one */
        if(!controllers[i].poll()){
          aui.controllerError = true;
          aui.controlerErrorTimeStamp = aui.millis();
          JFrame jf=new JFrame();
          jf.setAlwaysOnTop(true);
          JOptionPane.showMessageDialog(jf,"Controller Disconnected!\n======\n======\nThe program will now close!","Controller Disconnected!", JOptionPane.ERROR_MESSAGE);
          System.exit(420);
        }
        
        /* Get the controllers event queue */
        EventQueue queue = controllers[i].getEventQueue();
        
        /* Create an event object for the underlying plugin to populate */
        Event event = new Event();
        
        /* For each object in the queue */
        while (queue.getNextEvent(event)) {

          Component comp = event.getComponent();
          //get the new value of the attached component and pass it to the gamepad wrapper to handle
          float value = event.getValue();
          gp.updateComponent(comp.getIdentifier(),value);
        }
        
      }
  }
}
